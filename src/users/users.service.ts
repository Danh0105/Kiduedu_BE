import { In } from 'typeorm';
import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
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
import { CreateUserDto } from './dto/create-user.dto';

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

  async createUser(data: CreateUserDto): Promise<{ user: User; order: Order; items: OrderItem[] }> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const mgr = queryRunner.manager;
      const customerType = data.customerType ?? CustomerType.INDIVIDUAL;

      // 1️⃣ Tìm hoặc tạo user
      let savedUser = await mgr.getRepository(User).findOne({
        where: { email: data.email },
        relations: ['cart', 'addresses'],
      });

      if (!savedUser) {
        const user = mgr.create(User, {
          username: data.username,
          email: data.email,
          role: data.role ?? 'customer',
          customer_type: customerType,
        });
        savedUser = await mgr.save(user);

        // Giỏ hàng
        const cart = mgr.create(Cart, { user: savedUser });
        await mgr.save(cart);

        // Địa chỉ
        if (data.address) {
          const address = mgr.create(Address, { ...data.address, user: savedUser });
          await mgr.save(address);
        }

        // Hồ sơ
        if (customerType === CustomerType.BUSINESS) {
          const businessProfile = mgr.create(UserProfileBusiness, {
            user: savedUser,
            company_name: data.companyName,
            tax_id: data.taxId,
            email: data.businessEmail,
          });
          await mgr.save(businessProfile);
        } else {
          const individualProfile = mgr.create(UserProfileIndividual, {
            user: savedUser,
            full_name: data.fullName ?? '',
            ...(data.dateOfBirth ? { date_of_birth: new Date(data.dateOfBirth) } : {}),
          });
          await mgr.save(individualProfile);
        }
      }

      // 3️⃣ Validate danh sách biến thể
      const variantIds = (data.items ?? []).map((i) => i.variantId);
      if (variantIds.length === 0) {
        throw new BadRequestException('Items must not be empty');
      }

      const variantRepo = mgr.getRepository(ProductVariant);
      const variants = await variantRepo.find({
        where: { variantId: In(variantIds) },
        relations: ['product'],
      });

      const foundIds = new Set(variants.map((v) => v.variantId));
      const missing = variantIds.filter((id) => !foundIds.has(id));
      if (missing.length > 0) {
        throw new BadRequestException(`Variant(s) not found: ${missing.join(', ')}`);
      }

      // 4️⃣ Tính toán đơn hàng (dựa trên variant.price)
      const subtotal = data.items.reduce((sum, i) => {

        return sum + Number(i.prices) * Number(i.quantity);
      }, 0);

      const shipping_fee = 0;
      const total = subtotal + shipping_fee;

      const order = mgr.create(Order, {
        user: savedUser,
        subtotal,
        discount_amount: 0,
        total_amount: total,
        status: 'Pending',
      });
      const savedOrder = await mgr.save(order);

      // 5️⃣ Tạo order items (liên kết variant)
      const itemsEntities = data.items.map((i) => {
        const variant = variants.find((v) => v.variantId === i.variantId)!;
        return mgr.create(OrderItem, {
          order: savedOrder,
          variant, // ✅ liên kết variant thay vì product
          quantity: i.quantity,
          price_per_unit: Number(variant.prices), // ✅ lấy giá từ variant
        });
      });

      const savedItems = await mgr.save(itemsEntities);

      // 6️⃣ Commit transaction
      await queryRunner.commitTransaction();
      return { user: savedUser, order: savedOrder, items: savedItems };
    } catch (err) {
      await queryRunner.rollbackTransaction();
      throw err;
    } finally {
      await queryRunner.release();
    }
  }
}
