import { In } from 'typeorm';
import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { User, CustomerType } from './entities/user.entity';
import { Cart } from 'src/cart/entities/cart.entity';
import { Address } from './entities/address.entity';
import { UserProfileIndividual } from './entities/user_profile_individual.entity';
import { UserProfileBusiness } from './entities/user_profile_business.entity';
import { Order } from 'src/orders/entities/order.entity';
import { OrderItem } from 'src/orders/entities/order-item.entity';
import { ProductVariant } from 'src/products/entities/product-variant.entity';
import { AddressDto, CreateUserDto } from './dto/create-user.dto';

/* ================= Helpers ================= */

function slugifyUsername(s: string) {
  return (s || 'user')
    .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-zA-Z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .toLowerCase()
    .slice(0, 40);
}

async function generateUniqueUsername(mgr: any, desiredRaw: string): Promise<string> {
  const desired = slugifyUsername(desiredRaw || 'user');
  let candidate = desired || 'user';
  let n = 0;
  const repo = mgr.getRepository(User);
  // phòng khi DB còn UNIQUE(username)
  // eslint-disable-next-line no-constant-condition
  while (true) {
    const exists = await repo.exist({ where: { username: candidate } });
    if (!exists) return candidate;
    n += 1;
    candidate = `${desired}-${n}`.slice(0, 50);
  }
}


type AnyPrice = {
  price?: number | string;
  amount?: number | string;
  startAt?: string | Date;
  endAt?: string | Date | null;
  start_at?: string | Date;
  end_at?: string | Date | null;
  createdAt?: string | Date;
  created_at?: string | Date;
};

function pickActivePrice(prices?: AnyPrice[]): number | undefined {

  if (!prices || prices.length === 0) return undefined;
  const now = new Date();
  const toDate = (d?: string | Date | null) => (typeof d === 'string' ? new Date(d) : d ?? undefined);
  const active = prices.find((p) => {
    const start = toDate((p as any).startAt ?? (p as any).start_at);
    const end = toDate((p as any).endAt ?? (p as any).end_at);
    return (!start || start <= now) && (!end || end >= now);
  });
  const toNum = (v: any) => (v === undefined || v === null || v === '' ? undefined : Number(v));
  const val = (p?: AnyPrice) => (p ? toNum(p.price) ?? toNum((p as any).amount) : undefined);

  return val(active) ?? val(prices[0]);
}

/* ================= Service ================= */

@Injectable()
export class UsersService {
  constructor(
    private readonly dataSource: DataSource,

    @InjectRepository(User) private readonly usersRepository: Repository<User>,
    @InjectRepository(Cart) private readonly cartRepository: Repository<Cart>,
    @InjectRepository(Address) private readonly addressRepository: Repository<Address>,
    @InjectRepository(UserProfileBusiness) private readonly businessRepository: Repository<UserProfileBusiness>,
    @InjectRepository(UserProfileIndividual) private readonly individualRepository: Repository<UserProfileIndividual>,
  ) { }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email } });
  }

  /**
   * Gộp: nếu email đã tồn tại -> dùng user cũ; nếu không -> tạo user mới.
   * Sau đó tạo Order + OrderItems (bắt buộc có pricePerUnit).
   */
  async createUser(data: CreateUserDto): Promise<{ user: User; order: Order; items: OrderItem[] }> {

    if (!data?.email) throw new BadRequestException('Email is required');
    if (!Array.isArray(data.items) || data.items.length === 0) {
      throw new BadRequestException('Items must not be empty');
    }

    try {
      // cố gắng đường thẳng; nếu dính UNIQUE email (race) thì sẽ rơi vào catch với 23505
      return await this.createUserAndOrderTransactional(data);
    } catch (e: any) {
      // Race-condition: 2 request cùng email -> email unique văng 23505
      if (e?.code === '23505') {
        // retry: dùng user tồn tại & tạo order
        return await this.createOrderForExistingEmail(data);
      }
      throw e;
    }
  }

  /* ============ Core transactional path ============ */
  private normalizeStr(v?: string | null): string {
    return (v ?? '').trim().toLowerCase();
  }

  private isSameAddress(dto: AddressDto, entity: Address): boolean {
    return (
      this.normalizeStr(dto.full_name) === this.normalizeStr((entity as any).full_name ?? (entity as any).fullName) &&
      this.normalizeStr(dto.phone_number) === this.normalizeStr((entity as any).phone_number ?? (entity as any).phoneNumber) &&
      this.normalizeStr(dto.street) === this.normalizeStr(entity.street) &&
      this.normalizeStr(dto.ward) === this.normalizeStr(entity.ward) &&
      this.normalizeStr(dto.district) === this.normalizeStr(entity.district) &&
      this.normalizeStr(dto.city) === this.normalizeStr(entity.city)
    );
  }

  private async createUserAndOrderTransactional(data: CreateUserDto) {
    const qr = this.dataSource.createQueryRunner();
    await qr.connect();
    await qr.startTransaction();
    try {
      const mgr = qr.manager;
      const email = data.email.trim().toLowerCase();
      const customerType = data.customerType ?? CustomerType.INDIVIDUAL;

      // 1) lấy user theo email; nếu có -> dùng, nếu chưa -> tạo
      let savedUser = await mgr.getRepository(User).findOne({
        where: { email },
        relations: ['cart', 'addresses'],
      });

      let selectedAddress: Address | undefined;

      if (!savedUser) {
        const desiredUsername =
          data.username || (data.fullName ?? '').trim() || email.split('@')[0] || 'user';
        const username = await generateUniqueUsername(mgr, desiredUsername);

        savedUser = await mgr.save(
          mgr.create(User, {
            username,
            email,
            role: data.role ?? 'customer',
            customer_type: customerType,
          }),
        );

        await mgr.save(mgr.create(Cart, { user: savedUser }));

        if (data.address) {
          // user mới chắc chắn chưa có address, nên tạo luôn
          selectedAddress = await mgr.save(
            mgr.create(Address, { ...data.address, user: savedUser }),
          );
        }

        if (customerType === CustomerType.BUSINESS) {
          await mgr.save(
            mgr.create(UserProfileBusiness, {
              user: savedUser,
              company_name: data.companyName,
              tax_id: data.taxId,
              email: data.businessEmail,
            }),
          );
        } else {
          await mgr.save(
            mgr.create(UserProfileIndividual, {
              user: savedUser,
              full_name: data.fullName ?? '',
              ...(data.dateOfBirth ? { date_of_birth: new Date(data.dateOfBirth) } : {}),
            }),
          );
        }
      } else {
        // khách quay lại
        if (data.address) {
          const existingAddresses = savedUser.addresses ?? [];

          const existed = existingAddresses.find((addr) =>
            this.isSameAddress(data.address!, addr),
          );

          if (existed) {
            selectedAddress = existed;        // ✅ dùng lại địa chỉ cũ
          } else {
            selectedAddress = await mgr.save( // ✅ tạo mới nếu khác
              mgr.create(Address, { ...data.address, user: savedUser }),
            );
          }
        }
      }


      // 2) validate variants
      const variantIds = data.items.map((i) => i.variantId);
      const variants = await mgr.getRepository(ProductVariant).find({
        where: { variantId: In(variantIds) },
        relations: ['product', 'prices'],
      });
      const foundIds = new Set(variants.map((v) => v.variantId));
      const missing = variantIds.filter((id) => !foundIds.has(id));
      if (missing.length > 0) {
        throw new BadRequestException(`Variant(s) not found: ${missing.join(', ')}`);
      }

      // 3) tính tiền (ưu tiên dto.pricePerUnit, fallback lấy active price)

      const itemsEntities = data.items.map((i) => {
        const variant = variants.find((v) => v.variantId === i.variantId)!;

        if (!Number.isFinite(i.pricePerUnit)) {
          throw new BadRequestException(`Không xác định được giá cho variantId=${i.variantId}`);
        }

        const attributesSnapshot = i.attributes;

        return mgr.create(OrderItem, {
          order: undefined as any, // sẽ gán sau khi tạo order
          variant,
          quantity: i.quantity,
          pricePerUnit: i.pricePerUnit,    // ✅ camelCase
          attributes: attributesSnapshot,
        });
      });


      const subtotal = itemsEntities.reduce(
        (sum, it) => sum + Number(it.pricePerUnit) * Number(it.quantity),
        0,
      );
      const shipping_fee = 0;
      const total = subtotal + shipping_fee;

      const savedOrder = await mgr.save(
        mgr.create(Order, {
          user: savedUser,
          subtotal,
          discountAmount: 0,
          totalAmount: total,
          status: 'Pending',
          shippingAddress: selectedAddress ?? null,  // 👈 ĐỊA CHỈ GIAO HÀNG
        }),
      );




      // gán order cho từng item rồi save
      itemsEntities.forEach((it) => ((it as any).order = savedOrder));
      const savedItems = await mgr.save(itemsEntities);

      await qr.commitTransaction();
      return { user: savedUser, order: savedOrder, items: savedItems };
    } catch (err) {
      await qr.rollbackTransaction();
      throw err;
    } finally {
      await qr.release();
    }
  }

  /* ===== Retry path when email UNIQUE is hit (race) ===== */
  private async createOrderForExistingEmail(data: CreateUserDto) {
    const user = await this.usersRepository.findOne({ where: { email: data.email.trim().toLowerCase() } });
    if (!user) throw new BadRequestException('Email conflict but user not found. Retry later.');

    // tái dùng core logic tạo order/items cho user đã có
    const qr = this.dataSource.createQueryRunner();
    await qr.connect();
    await qr.startTransaction();
    try {
      const mgr = qr.manager;

      // load variants
      const variantIds = data.items.map((i) => i.variantId);
      const variants = await mgr.getRepository(ProductVariant).find({
        where: { variantId: In(variantIds) },
        relations: ['product', 'prices'],
      });
      const foundIds = new Set(variants.map((v) => v.variantId));
      const missing = variantIds.filter((id) => !foundIds.has(id));
      if (missing.length > 0) {
        throw new BadRequestException(`Variant(s) not found: ${missing.join(', ')}`);
      }

      // build items


      const itemsEntities = data.items.map((i) => {
        const variant = variants.find((v) => v.variantId === i.variantId)!;
        const unitPriceRaw =
          i.pricePerUnit ?? pickActivePrice((variant as any).prices);
        const unitPrice = Number(unitPriceRaw);
        if (!Number.isFinite(unitPrice)) {
          throw new BadRequestException(`Không xác định được giá cho variantId=${i.variantId}`);
        }
        const attributesSnapshot = i.attributes;
        return mgr.create(OrderItem, {
          order: undefined as any,
          variant,
          quantity: i.quantity,
          pricePerUnit: unitPrice,
          attributes: attributesSnapshot,
        });
      });

      const subtotal = itemsEntities.reduce(
        (sum, it) => sum + Number(it.pricePerUnit) * Number(it.quantity),
        0,
      );
      const savedOrder = await mgr.save(
        mgr.create(Order, {
          user,
          subtotal,
          discountAmount: 0,     // ✅
          totalAmount: subtotal,  // ✅
          status: 'Pending',
        }),
      );

      itemsEntities.forEach((it) => ((it as any).order = savedOrder));
      const savedItems = await mgr.save(itemsEntities);

      await qr.commitTransaction();
      return { user, order: savedOrder, items: savedItems };
    } catch (err) {
      await qr.rollbackTransaction();
      throw err;
    } finally {
      await qr.release();
    }
  }
}

