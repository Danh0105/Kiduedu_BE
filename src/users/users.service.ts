import { In } from 'typeorm';
import { Injectable, BadRequestException, Redirect } from '@nestjs/common';
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
import { Product } from 'src/products/entities/product.entity';
import { AddressDto, CreateUserDto } from './dto/create-user.dto';
import { EmailQueueService } from 'src/email/email.queue.service';

import * as crypto from 'crypto';
import * as nodemailer from 'nodemailer';

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
  const toDate = (d?: string | Date | null) =>
    typeof d === 'string' ? new Date(d) : d ?? undefined;

  const active = prices.find((p) => {
    const start = toDate((p as any).startAt ?? (p as any).start_at);
    const end = toDate((p as any).endAt ?? (p as any).end_at);
    return (!start || start <= now) && (!end || end >= now);
  });

  const toNum = (v: any) =>
    v === undefined || v === null || v === '' ? undefined : Number(v);
  const val = (p?: AnyPrice) =>
    p ? toNum(p.price) ?? toNum((p as any).amount) : undefined;

  return val(active) ?? val(prices[0]);
}

/* ================= SERVICE ================= */

@Injectable()
export class UsersService {
  constructor(
    private readonly dataSource: DataSource,
    @InjectRepository(User) private readonly usersRepository: Repository<User>,

    private readonly emailQueueService: EmailQueueService,
  ) { }

  /* ==== EMAIL VERIFY HELPERS (đúng vị trí) ==== */

  private generateVerifyToken() {
    return crypto.randomBytes(32).toString('hex');
  }

  private async sendVerificationEmail(email: string, token: string) {
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.MAIL_USER,
        pass: process.env.MAIL_PASS,
      },
    });

    const link = `https://your-domain.com/auth/verify-email?token=${token}`;

    await transporter.sendMail({
      from: 'IchiSkill <no-reply@ichiskill.vn>',
      to: email,
      subject: 'Xác thực email tài khoản',
      html: `
        <p>Nhấn vào nút bên dưới để xác thực tài khoản:</p>
        <a style="
          padding: 10px 16px;
          background: #4CAF50;
          color: white;
          text-decoration: none;
          border-radius: 6px;
        " href="${link}">Xác thực email</a>
        <p>Nếu bạn không yêu cầu, hãy bỏ qua email này.</p>
      `,
    });
  }

  /* ================= Core ================= */

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email } });
  }

  async createUser(data: CreateUserDto): Promise<{
    user: User;
    order: Order | null;
    items: OrderItem[] | null;
    message?: string;
  }> {
    if (!data?.email) throw new BadRequestException('Email is required');
    if (!Array.isArray(data.items) || data.items.length === 0) {
      throw new BadRequestException('Items must not be empty');
    }

    try {
      return await this.createUserAndOrderTransactional(data);
    } catch (e: any) {
      if (e?.code === '23505') {
        return await this.createOrderForExistingEmail(data);
      }
      throw e;
    }
  }

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

  private async resolveAddress(mgr: EntityManager, user: User, addressDto?: AddressDto): Promise<Address | null> {
    if (!addressDto) return null;

    const existingAddresses = user.addresses ?? [];
    const existed = existingAddresses.find((addr) => this.isSameAddress(addressDto, addr));

    if (existed) return existed;

    return await mgr.save(mgr.create(Address, { ...addressDto, user }));
  }

  /* ========== CREATE USER + ORDER TRANSACTION ========== */

  private async createUserAndOrderTransactional(data: CreateUserDto) {
    const qr = this.dataSource.createQueryRunner();
    await qr.connect();
    await qr.startTransaction();

    try {
      const mgr = qr.manager;
      const email = data.email.trim().toLowerCase();
      const customerType = data.customerType ?? CustomerType.INDIVIDUAL;

      /* =============================
        1) KIỂM TRA USER ĐÃ TỒN TẠI?
      ============================== */
      let savedUser = await mgr.getRepository(User).findOne({
        where: { email },
        relations: ['cart', 'addresses'],
      });

      /* 🚨 Nếu user đã tồn tại nhưng CHƯA xác thực → chặn tạo đơn + gửi lại email */
      if (savedUser && !savedUser.emailVerified) {
        // Gửi lại email xác thực
        const newVerifyToken = this.generateVerifyToken();
        savedUser.verifyToken = newVerifyToken;
        await mgr.save(savedUser);

        await this.emailQueueService.addVerifyEmailJob(email, newVerifyToken);

        await qr.commitTransaction();

        return {
          user: savedUser,
          order: null,
          items: [],
          message: "Email chưa được xác thực. Vui lòng kiểm tra email để xác thực tài khoản trước khi đặt hàng."
        };
      }

      /* ===============================
        2) USER CHƯA TỒN TẠI → TẠO MỚI
      =============================== */
      if (!savedUser) {
        const desiredUsername = data.username || (data.fullName ?? '').trim() || email.split('@')[0];
        const username = await generateUniqueUsername(mgr, desiredUsername);

        const verifyToken = this.generateVerifyToken();

        savedUser = await mgr.save(
          mgr.create(User, {
            username,
            email,
            role: data.role ?? 'customer',
            customer_type: customerType,
            emailVerified: false,
            verifyToken,
          }),
        );

        // Gửi mail verify
        await this.emailQueueService.addVerifyEmailJob(email, verifyToken);
        console.log("JOB SENT → EMAIL:", email, verifyToken);

        // Tạo giỏ hàng
        await mgr.save(mgr.create(Cart, { user: savedUser }));

        // Tạo profile
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

        /* 🚨 User mới → CHẶN tạo đơn cho đến khi xác thực */
        await qr.commitTransaction();

        return {
          user: savedUser,
          order: null,
          items: [],
          message: "Vui lòng kiểm tra email và xác thực tài khoản trước khi tạo đơn hàng."
        };
      }

      /* ===============================
        3) USER ĐÃ TỒN TẠI & ĐÃ VERIFY
           → ĐƯỢC TẠO ĐƠN HÀNG
      =============================== */

      if (!savedUser.addresses) savedUser.addresses = [];
      const selectedAddress = await this.resolveAddress(mgr, savedUser, data.address);

      const { order, items } = await this._createOrderProcess(mgr, savedUser, data.items, selectedAddress);
      await this.emailQueueService.addOrderSuccessNotifyJob({
        orderId: order.orderId,
        totalAmount: order.totalAmount,
        user: savedUser
      });

      await qr.commitTransaction();
      return { user: savedUser, order, items };

    } catch (err) {
      await qr.rollbackTransaction();
      throw err;
    } finally {
      await qr.release();
    }
  }


  /* ========== EXISTING USER RETRY PATH ========== */

  private async createOrderForExistingEmail(data: CreateUserDto) {
    const user = await this.usersRepository.findOne({
      where: { email: data.email.trim().toLowerCase() },
      relations: ['addresses'],
    });

    if (!user) throw new BadRequestException('Email conflict but user not found.');

    const qr = this.dataSource.createQueryRunner();
    await qr.connect();
    await qr.startTransaction();

    try {
      const mgr = qr.manager;
      const selectedAddress = await this.resolveAddress(mgr, user, data.address);

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

  /* ========== CREATE ORDER LOGIC ========== */

  private async _createOrderProcess(
    mgr: EntityManager,
    user: User,
    itemsDto: any[],
    shippingAddress: Address | null,
  ) {
    const variantIds = itemsDto.filter((i) => i.variantId).map((i) => i.variantId);
    const productIds = itemsDto.filter((i) => i.productId && !i.variantId).map((i) => i.productId);

    let variants: ProductVariant[] = [];
    let products: Product[] = [];

    if (variantIds.length > 0) {
      variants = await mgr.getRepository(ProductVariant).find({
        where: { variantId: In(variantIds) },
        relations: ['product', 'prices'],
      });
    }

    if (productIds.length > 0) {
      products = await mgr.getRepository(Product).find({
        where: { productId: In(productIds) },
      });
    }

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

    const itemsEntities = itemsDto.map((i) => {
      let variantEntity: ProductVariant | null = null;
      let productIdValue: number | null = null;
      let dbPrice: number | undefined;

      if (i.variantId) {
        variantEntity = variants.find((v) => v.variantId === i.variantId) || null;

        productIdValue = variantEntity?.product
          ? (variantEntity.product as any).productId ?? (variantEntity.product as any).id
          : null;

        dbPrice = pickActivePrice((variantEntity as any).prices);
      } else if (i.productId) {
        const productEntity = products.find((p) => p.productId === i.productId);
        variantEntity = null;

        productIdValue = productEntity!.productId;

        dbPrice = pickActivePrice((productEntity as any).prices);
      }

      const finalPrice =
        i.pricePerUnit !== undefined ? Number(i.pricePerUnit) : Number(dbPrice);

      if (!Number.isFinite(finalPrice)) {
        throw new BadRequestException(
          `Không xác định được giá cho item (Variant: ${i.variantId}, Product: ${i.productId})`,
        );
      }

      return mgr.create(OrderItem, {
        variant: variantEntity,
        productId: productIdValue,
        quantity: i.quantity,
        pricePerUnit: finalPrice,
        attributes: i.attributes || {},
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
        discountAmount: 0,
        totalAmount: subtotal,
        status: 'Pending',
        shippingAddress,
      }),
    );

    itemsEntities.forEach((it) => (it.order = savedOrder));
    const savedItems = await mgr.save(itemsEntities);

    return { order: savedOrder, items: savedItems };
  }

  /* ========= VERIFY EMAIL API ========= */

  async verifyEmail(token: string) {
    const user = await this.usersRepository.findOne({
      where: { verifyToken: token },
    });

    if (!user) {
      throw new BadRequestException('Token không hợp lệ hoặc đã hết hạn');
    }

    user.emailVerified = true;
    user.verifyToken = null;

    await this.usersRepository.save(user);
    return { success: true };

  }
}
