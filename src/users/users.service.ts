import { In, Not } from 'typeorm';
import { Injectable, BadRequestException, Redirect, NotFoundException, ForbiddenException } from '@nestjs/common';
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
import { AddressDto, CreateUserDto, PaymentMethod } from './dto/create-user.dto';
import { EmailQueueService } from 'src/email/email.queue.service';
import * as bcrypt from 'bcryptjs';
import { UserPermission } from './entities/user-permission.entity';
import * as crypto from 'crypto';
import * as nodemailer from 'nodemailer';
import { Role } from 'src/role/entities/role.entity';
import { CreateUserAdminDto } from './dto/create-user-admin';
import { Permission } from '../permission/entities/permission.entity';
import { Promotion } from '../promotions/entities/promotion.entity';

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
    @InjectRepository(Role) private readonly roleRepository: Repository<Role>,
    @InjectRepository(Permission)
    private readonly permissionRepo: Repository<Permission>,
    @InjectRepository(UserPermission)
    private readonly userPermissionRepo: Repository<UserPermission>,
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
    return this.usersRepository.findOne({
      where: { email },
      relations: {
        role: {
          permissions: true,
        },
      },
    });
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
      /*   if (savedUser && !savedUser.emailVerified) {
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
        } */

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
            role: { id: 3 },
            customer_type: customerType,
            emailVerified: false,
            verifyToken,
          }),
        );

        // Gửi mail verify
        /*   await this.emailQueueService.addVerifyEmailJob(email, verifyToken);
          console.log("JOB SENT → EMAIL:", email, verifyToken); */

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

      const { order, items } = await this._createOrderProcess(
        mgr,
        savedUser,
        data.items,
        selectedAddress,
        data.paymentMethod,
        data.promotionId ?? undefined,
      );
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

      const { order, items } = await this._createOrderProcess(mgr, user, data.items, selectedAddress, data.paymentMethod);

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
    paymentMethod: PaymentMethod,
    promotionId?: number,
  ) {
    /* ===============================
       1) LOAD VARIANTS
    =============================== */

    const variantIds = itemsDto.map((i) => i.variantId);

    const variants = await mgr.getRepository(ProductVariant).find({
      where: { variantId: In(variantIds) },
      relations: ['product', 'prices'],
    });

    const foundVariantIds = new Set(variants.map((v) => v.variantId));
    const missing = variantIds.filter((id) => !foundVariantIds.has(id));

    if (missing.length > 0) {
      throw new BadRequestException(
        `Variant(s) not found: ${missing.join(', ')}`,
      );
    }

    /* ===============================
       2) MAP ORDER ITEMS
    =============================== */

    const itemsEntities = itemsDto.map((i) => {
      const variant = variants.find((v) => v.variantId === i.variantId)!;

      const dbPrice = pickActivePrice((variant as any).prices);
      const finalPrice =
        i.pricePerUnit !== undefined
          ? Number(i.pricePerUnit)
          : Number(dbPrice);

      if (!Number.isFinite(finalPrice)) {
        throw new BadRequestException(
          `Không xác định được giá cho variant ${i.variantId}`,
        );
      }

      return mgr.create(OrderItem, {
        variant,
        quantity: Number(i.quantity),
        pricePerUnit: finalPrice,
        attributes: i.attributes || {},
      });
    });

    /* ===============================
       3) CALC SUBTOTAL
    =============================== */

    const subtotal = itemsEntities.reduce(
      (sum, it) => sum + Number(it.pricePerUnit) * Number(it.quantity),
      0,
    );

    if (subtotal <= 0) {
      throw new BadRequestException('Subtotal không hợp lệ');
    }

    /* ===============================
       4) VALIDATE PROMOTION
    =============================== */

    let promotion: Promotion | null = null;
    let discountAmount = 0;

    if (promotionId) {
      promotion = await mgr.getRepository(Promotion).findOne({
        where: {
          id: promotionId,
          isActive: true,
        },
        lock: { mode: 'pessimistic_write' }, // 🔒 chống race condition voucher
      });

      if (!promotion) {
        throw new BadRequestException('Khuyến mãi không hợp lệ');
      }

      const now = new Date();
      if (now < promotion.startDate || now > promotion.endDate) {
        throw new BadRequestException('Khuyến mãi đã hết hạn');
      }

      // 🎯 TÍNH GIẢM GIÁ
      if (promotion.discountType === 'percentage') {
        discountAmount = Math.floor(
          (subtotal * Number(promotion.discountValue)) / 100,
        );
      } else {
        discountAmount = Number(promotion.discountValue);
      }

      // Không cho giảm quá subtotal
      discountAmount = Math.min(discountAmount, subtotal);

      // 🎟️ VALIDATE VOUCHER
      if (promotion.isVoucher) {
        if (
          promotion.usageLimit !== null &&
          promotion.usageLimit !== undefined &&
          promotion.usedCount >= promotion.usageLimit
        ) {
          throw new BadRequestException('Voucher đã hết lượt sử dụng');
        }
      }

    }

    /* ===============================
       5) CREATE ORDER (ONLY ONCE)
    =============================== */

    const totalAmount = subtotal - discountAmount;

    const savedOrder = await mgr.save(
      mgr.create(Order, {
        user,
        subtotal,
        discountAmount,
        totalAmount,
        status: 'Pending',
        paymentMethod,
        paymentStatus: 'Pending',
        shippingAddress,
        promotion,
        promotionId: promotion?.id ?? null,
      }),
    );

    /* ===============================
       6) SAVE ORDER ITEMS
    =============================== */

    itemsEntities.forEach((it) => (it.order = savedOrder));
    const savedItems = await mgr.save(itemsEntities);

    /* ===============================
       7) UPDATE VOUCHER USAGE
    =============================== */

    if (promotion?.isVoucher) {
      promotion.usedCount += 1;
      await mgr.save(promotion);
    }

    return {
      order: savedOrder,
      items: savedItems,
    };
  }


  /* ========= VERIFY EMAIL API ========= */

  /* async verifyEmail(token: string) {
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

  } */
  async findAllPaginated(
    page = 1,
    limit = 10,
    keyword?: string,
  ) {
    const qb = this.usersRepository
      .createQueryBuilder('user')
      .leftJoinAndSelect('user.role', 'role')
      .select([
        'user.user_id',
        'user.username',
        'user.email',
        'user.customer_type',
        'user.emailVerified',
        'user.created_at',
        'role.id',
        'role.name',
      ])
      .where('user.user_id != :excludedId', { excludedId: 1 })
      .andWhere('role.name != :customerRole', { customerRole: 'CUSTOMER' })
      .orderBy('user.created_at', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);


    if (keyword) {
      qb.andWhere(
        '(user.username LIKE :keyword OR user.email LIKE :keyword)',
        { keyword: `%${keyword}%` },
      );
    }

    const [data, total] = await qb.getManyAndCount();

    return {
      data,
      total,
      page,
      limit,
    };
  }

  async createAdmin(dto: CreateUserAdminDto) {
    const role = await this.roleRepository.findOne({
      where: { id: dto.id },
    });

    if (!role) {
      throw new BadRequestException('Vai trò không tồn tại');
    }

    const user = this.usersRepository.create({
      username: dto.name,
      email: dto.email,
      password_hash: await bcrypt.hash(dto.password, 10),
      role: { id: role.id },
    });

    return this.usersRepository.save(user);
  }
  async deleteUserByAdmin(userId: number, adminId: number) {
    if (userId === adminId) {
      throw new ForbiddenException('Không thể tự xóa chính mình');
    }

    const user = await this.usersRepository.findOne({
      where: { user_id: userId },
      relations: ['role'],
    });

    if (!user) {
      throw new NotFoundException('Người dùng không tồn tại');
    }

    // 🔒 (Tuỳ chọn) Chỉ cho xóa ADMIN & STAFF
    if (![1, 2].includes(user.role.id)) {
      throw new BadRequestException('Không được phép xóa tài khoản USER');
    }

    await this.usersRepository.remove(user);

    return {
      message: 'Xóa tài khoản thành công',
      user_id: userId,
    };
  }
  async getEffectivePermissions(userId: number) {
    const user = await this.usersRepository.findOne({
      where: { user_id: userId },
      relations: [
        'role',
        'role.permissions',
        'permissionOverrides',
        'permissionOverrides.permission',
      ],
    });

    if (!user) throw new NotFoundException('User not found');

    const map = new Map<number, Permission>();

    // 1️⃣ Quyền từ role
    user.role?.permissions?.forEach(p => {
      map.set(p.id, p);
    });

    // 2️⃣ Quyền cá nhân (override)
    user.permissionOverrides.forEach(op => {
      if (op.granted) {
        map.set(op.permission.id, op.permission);
      } else {
        map.delete(op.permission.id);
      }
    });

    return Array.from(map.values());
  }
  async findUsersWithPermissions() {
    return this.usersRepository.find({
      relations: {
        role: {
          permissions: true,
        },
      },
      where: {
        user_id: Not(1),
        role: {
          name: Not('CUSTOMER'),
        },
      },
      order: {
        user_id: 'ASC',
      },
    });
  }


  async grantUserPermissions(userId: number, permissionIds: number[]) {
    const user = await this.usersRepository.findOneBy({ user_id: userId });
    if (!user) throw new NotFoundException('User not found');

    const permissions = await this.permissionRepo.findBy({
      id: In(permissionIds),
    });

    for (const p of permissions) {
      await this.userPermissionRepo.save({
        userId,
        permissionId: p.id,
        granted: true,
      });
    }

    return this.getEffectivePermissions(userId);
  }
  async revokeUserPermissions(userId: number, permissionIds: number[]) {
    const user = await this.usersRepository.findOneBy({ user_id: userId });
    if (!user) throw new NotFoundException('User not found');

    for (const pid of permissionIds) {
      await this.userPermissionRepo.save({
        userId,
        permissionId: pid,
        granted: false, // 🔥 override
      });
    }

    return this.getEffectivePermissions(userId);
  }
  async updateUserRole(userId: number, roleId: number) {
    const user = await this.usersRepository.findOne({
      where: { user_id: userId },
    });
    if (!user) throw new NotFoundException('User not found');

    const role = await this.roleRepository.findOneBy({ id: roleId });
    if (!role) throw new NotFoundException('Role not found');

    user.role = role;
    return this.usersRepository.save(user);
  }

}
