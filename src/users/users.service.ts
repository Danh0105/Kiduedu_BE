import { In } from 'typeorm';
import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource, EntityManager } from 'typeorm';
import { User, CustomerType } from './entities/user.entity';
import { Cart } from 'src/cart/entities/cart.entity';
import { Address } from './entities/address.entity';
import { UserProfileIndividual } from './entities/user_profile_individual.entity';
import { UserProfileBusiness } from './entities/user_profile_business.entity';
import { Order } from 'src/orders/entities/order.entity';
import { OrderItem } from 'src/orders/entities/order-item.entity';
import { ProductVariant } from 'src/products/entities/product-variant.entity';
import { Product } from 'src/products/entities/product.entity'; // ✅ Import thêm Product
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
type AnyPrice = {
  price?: number | string;
  amount?: number | string;
  startAt?: string | Date;
  endAt?: string | Date | null;
  // ... các trường khác
};
async function generateUniqueUsername(mgr: any, desiredRaw: string): Promise<string> {
  const desired = slugifyUsername(desiredRaw || 'user');
  let candidate = desired || 'user';
  let n = 0;
  const repo = mgr.getRepository(User);
  while (true) {
    const exists = await repo.exist({ where: { username: candidate } });
    if (!exists) return candidate;
    n += 1;
    candidate = `${desired}-${n}`.slice(0, 50);
  }
}
function pickActivePrice(prices?: AnyPrice[]): number | undefined {
  if (!prices || prices.length === 0) return undefined;
  const now = new Date();
  const toDate = (d?: string | Date | null) => (typeof d === 'string' ? new Date(d) : d ?? undefined);

  // Tìm giá đang active
  const active = prices.find((p) => {
    const start = toDate((p as any).startAt ?? (p as any).start_at);
    const end = toDate((p as any).endAt ?? (p as any).end_at);
    return (!start || start <= now) && (!end || end >= now);
  });

  const toNum = (v: any) => (v === undefined || v === null || v === '' ? undefined : Number(v));
  const val = (p?: AnyPrice) => (p ? toNum(p.price) ?? toNum((p as any).amount) : undefined);

  return val(active) ?? val(prices[0]);
}
@Injectable()
export class UsersService {
  constructor(
    private readonly dataSource: DataSource,
    @InjectRepository(User) private readonly usersRepository: Repository<User>,
    // Các repository khác nếu cần dùng trực tiếp bên ngoài transaction...
  ) { }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email } });
  }

  async createUser(data: CreateUserDto): Promise<{ user: User; order: Order; items: OrderItem[] }> {
    if (!data?.email) throw new BadRequestException('Email is required');
    if (!Array.isArray(data.items) || data.items.length === 0) {
      throw new BadRequestException('Items must not be empty');
    }

    try {
      return await this.createUserAndOrderTransactional(data);
    } catch (e: any) {
      // Race-condition: 23505 là mã lỗi Unique violation trong Postgres
      if (e?.code === '23505') {
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

  // Hàm helper để xử lý/tạo Address
  private async resolveAddress(mgr: EntityManager, user: User, addressDto?: AddressDto): Promise<Address | null> {
    if (!addressDto) return null;

    const existingAddresses = user.addresses ?? [];
    // Nếu user mới được tạo, existingAddresses sẽ rỗng (trừ khi load relations sau khi save)
    // Logic ở đây: Check xem user đã có địa chỉ này chưa
    const existed = existingAddresses.find((addr) => this.isSameAddress(addressDto, addr));

    if (existed) {
      return existed;
    }

    // Tạo mới
    return await mgr.save(
      mgr.create(Address, { ...addressDto, user: user }),
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

      // 1) Lấy hoặc tạo User
      let savedUser = await mgr.getRepository(User).findOne({
        where: { email },
        relations: ['cart', 'addresses'],
      });

      if (!savedUser) {
        const desiredUsername = data.username || (data.fullName ?? '').trim() || email.split('@')[0] || 'user';
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
      }

      // 2) Xử lý Address
      // Nếu user mới tạo, relations 'addresses' là undefined/empty.
      // Nếu user cũ, đã load ở trên.
      if (!savedUser.addresses) savedUser.addresses = [];
      const selectedAddress = await this.resolveAddress(mgr, savedUser, data.address);

      // 3) Gọi hàm chung để xử lý Items và tạo Order (Hỗ trợ Product + Variant)
      const { order, items } = await this._createOrderProcess(mgr, savedUser, data.items, selectedAddress);

      await qr.commitTransaction();
      return { user: savedUser, order, items };

    } catch (err) {
      await qr.rollbackTransaction();
      throw err;
    } finally {
      await qr.release();
    }
  }

  /* ===== Retry path when email UNIQUE is hit (race) ===== */
  private async createOrderForExistingEmail(data: CreateUserDto) {
    // Load user lại
    const user = await this.usersRepository.findOne({
      where: { email: data.email.trim().toLowerCase() },
      relations: ['addresses'] // Load address để check trùng
    });

    if (!user) throw new BadRequestException('Email conflict but user not found. Retry later.');

    const qr = this.dataSource.createQueryRunner();
    await qr.connect();
    await qr.startTransaction();
    try {
      const mgr = qr.manager;

      // Xử lý Address cho user cũ (nếu họ gửi kèm địa chỉ mới)
      const selectedAddress = await this.resolveAddress(mgr, user, data.address);

      // Gọi hàm chung
      const { order, items } = await this._createOrderProcess(mgr, user, data.items, selectedAddress);

      await qr.commitTransaction();
      return { user, order, items };
    } catch (err) {
      await qr.rollbackTransaction();
      throw err;
    } finally {
      await qr.release();
    }
  }

  /**
   * --------------------------------------------------------
   * Logic cốt lõi: Map Items (Product/Variant) -> Tính tiền -> Lưu Order
   * --------------------------------------------------------
   */
  private async _createOrderProcess(
    mgr: EntityManager,
    user: User,
    itemsDto: any[],
    shippingAddress: Address | null,
  ) {
    // 1. Tách danh sách ID cần query
    const variantIds = itemsDto
      .filter((i) => i.variantId)
      .map((i) => i.variantId);

    const productIds = itemsDto
      .filter((i) => i.productId && !i.variantId) // Chỉ lấy productId nếu không có variantId
      .map((i) => i.productId);

    // 2. Query dữ liệu từ DB
    let variants: ProductVariant[] = [];
    let products: Product[] = [];

    if (variantIds.length > 0) {
      variants = await mgr.getRepository(ProductVariant).find({
        where: { variantId: In(variantIds) },
        relations: ['product', 'prices'], // Load prices để fallback nếu cần
      });
    }

    if (productIds.length > 0) {
      products = await mgr.getRepository(Product).find({
        where: { productId: In(productIds) },
      });
    }


    // 3. Validate: Đảm bảo ID gửi lên tồn tại trong DB
    const foundVariantIds = new Set(variants.map((v) => v.variantId));
    const missingVariants = variantIds.filter((id) => !foundVariantIds.has(id));
    if (missingVariants.length > 0) {
      throw new BadRequestException(`Variant(s) not found: ${missingVariants.join(', ')}`);
    }

    const foundProductIds = new Set(products.map((p) => p.productId));
    const missingProducts = productIds.filter((id) => !foundProductIds.has(id));
    if (missingProducts.length > 0) {
      throw new BadRequestException(`Product(s) not found: ${missingProducts.join(', ')}`);
    }

    // 4. Map DTO sang Entity OrderItem
    const itemsEntities = itemsDto.map((i) => {
      let variantEntity: ProductVariant | null = null;
      let productIdValue: number | null = null;
      let dbPrice: number | undefined = undefined;

      // --- Case A: Item có Variant ---
      if (i.variantId) {
        variantEntity = variants.find((v) => v.variantId === i.variantId) || null;
        if (!variantEntity) throw new BadRequestException(`Variant ${i.variantId} not found`); // Double check

        // Logic: Nếu là Variant, ta lưu relation Variant. 
        // Có thể lưu thêm productId cha vào cột 'product' nếu muốn (tùy nghiệp vụ), 
        // ở đây mình sẽ để productIdValue = variantEntity.productId (nếu có) hoặc null.
        productIdValue = variantEntity.product ? (variantEntity.product as any).productId ?? (variantEntity.product as any).id : null;

        // Lấy giá từ variant
        dbPrice = pickActivePrice((variantEntity as any).prices);
      }
      // --- Case B: Item chỉ có Product (không Variant) ---
      else if (i.productId) {
        const productEntity = products.find((p) => p.productId === i.productId);
        if (!productEntity) throw new BadRequestException(`Product ${i.productId} not found`);

        variantEntity = null;
        productIdValue = productEntity.productId; // Lưu ID vào cột 'product'

        // Lấy giá từ product
        dbPrice = pickActivePrice((productEntity as any).prices);
      }
      else {
        throw new BadRequestException(`Item phải có productId hoặc variantId`);
      }

      // --- Xử lý Giá (Ưu tiên DTO > DB) ---
      const finalPrice = i.pricePerUnit !== undefined && i.pricePerUnit !== null
        ? Number(i.pricePerUnit)
        : Number(dbPrice);

      if (!Number.isFinite(finalPrice)) {
        throw new BadRequestException(
          `Không xác định được giá cho item (Variant: ${i.variantId}, Product: ${i.productId})`
        );
      }

      // --- Tạo Entity ---
      // Lưu ý: Theo Entity bạn gửi:
      // 'variant' là Relation -> truyền object Entity
      // 'product' là Column (int) -> truyền number ID
      return mgr.create(OrderItem, {
        // order: sẽ gán sau
        variant: variantEntity, // TypeORM tự map vào cột variant_id
        productId: productIdValue,
        quantity: i.quantity,
        pricePerUnit: finalPrice,
        attributes: i.attributes || {},
      } as any); // 'as any' để tránh các lỗi type checking quá khắt khe của DeepPartial khi mix relation/column
    });

    // 5. Tính toán tổng tiền
    const subtotal = itemsEntities.reduce(
      (sum, it) => sum + Number(it.pricePerUnit) * Number(it.quantity),
      0,
    );
    const shipping_fee = 0;
    const total = subtotal + shipping_fee;

    // 6. Lưu Order
    const savedOrder = await mgr.save(
      mgr.create(Order, {
        user: user,
        subtotal,
        discountAmount: 0,
        totalAmount: total,
        status: 'Pending',
        shippingAddress: shippingAddress ?? null,
      }),
    );

    // 7. Gán Order vào Items và lưu
    // Vì OrderItem có @ManyToOne Order, ta gán object order vào
    itemsEntities.forEach((it) => {
      it.order = savedOrder;
    });

    const savedItems = await mgr.save(itemsEntities);

    return { order: savedOrder, items: savedItems };
  }
}