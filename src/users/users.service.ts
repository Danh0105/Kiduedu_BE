import * as bcrypt from 'bcryptjs';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { User, CustomerType } from './entities/user.entity';
import { Cart } from 'src/cart/entities/cart.entity';
import { Address } from './entities/address.entity';
import { UserProfileIndividual } from './entities/user_profile_individual.entity';
import { UserProfileBusiness } from './entities/user_profile_business.entity';
import { Order } from 'src/orders/entities/order.entity';
import { OrderItem } from 'src/orders/entities/order-item.entity';

@Injectable()
export class UsersService {
  constructor(
    private dataSource: DataSource, // ✅ thêm DataSource để tạo transaction

    @InjectRepository(User)
    private usersRepository: Repository<User>,

    @InjectRepository(Cart)
    private cartRepository: Repository<Cart>,

    @InjectRepository(Address)
    private addressRepository: Repository<Address>,

    @InjectRepository(UserProfileBusiness)
    private businessRepository: Repository<UserProfileBusiness>,

    @InjectRepository(UserProfileIndividual)
    private individualRepository: Repository<UserProfileIndividual>,
  ) { }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email } });
  }

  async createUser(data: {
    username: string;
    email: string;
    role?: string;
    customerType?: CustomerType;
    companyName?: string;
    taxId?: string;
    businessEmail?: string;
    fullName?: string;
    dateOfBirth?: Date;
    address?: {
      full_name: string;
      phone_number: string;
      street: string;
      ward: string;
      district: string;
      city: string;
      is_default?: boolean;
    };
    items: { product_id: number; quantity: number; price_per_unit: number }[];
  }): Promise<{ user: User; order: Order; items: OrderItem[] }> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1️⃣ Tạo User
      const user = queryRunner.manager.create(User, {
        username: data.username,
        email: data.email,
        role: data.role ?? 'customer',
        customer_type: data.customerType ?? CustomerType.INDIVIDUAL,
      });
      const savedUser = await queryRunner.manager.save(user);

      // 2️⃣ Tạo Cart mặc định
      const cart = queryRunner.manager.create(Cart, { user: savedUser });
      await queryRunner.manager.save(cart);

      // 3️⃣ Nếu có địa chỉ thì lưu Address
      if (data.address) {
        const address = queryRunner.manager.create(Address, {
          ...data.address,
          user: savedUser,
        });
        await queryRunner.manager.save(address);
      }

      // 4️⃣ Nếu là doanh nghiệp thì lưu profile business
      if (data.customerType === CustomerType.BUSINESS) {
        const businessProfile = queryRunner.manager.create(UserProfileBusiness, {
          user_id: savedUser.user_id,
          company_name: data.companyName,
          tax_id: data.taxId,
          email: data.businessEmail,
          user: savedUser,
        });
        await queryRunner.manager.save(businessProfile);
      }

      // 5️⃣ Nếu là cá nhân thì lưu profile individual
      if (
        !data.customerType ||
        data.customerType === CustomerType.INDIVIDUAL
      ) {
        const individualProfile = queryRunner.manager.create(
          UserProfileIndividual,
          {
            full_name: data.fullName ?? '',
            ...(data.dateOfBirth ? { date_of_birth: data.dateOfBirth } : {}),
            user: savedUser,
          },
        );
        await queryRunner.manager.save(individualProfile);
      }

      // 6️⃣ Tính toán order
      const subtotal = data.items.reduce(
        (sum, i) => sum + i.price_per_unit * i.quantity,
        0,
      );
      const shipping_fee = 38000; // ví dụ phí ship
      const total = subtotal + shipping_fee;

      const order = queryRunner.manager.create(Order, {
        user: savedUser,
        subtotal,
        discount_amount: 0,
        total_amount: total,
        status: 'Pending',
      });
      const savedOrder = await queryRunner.manager.save(order);

      // 7️⃣ Tạo OrderItems
      const orderItems = data.items.map((i) =>
        queryRunner.manager.create(OrderItem, {
          order: savedOrder,
          product: { product_id: i.product_id } as any,
          quantity: i.quantity,
          price_per_unit: i.price_per_unit,
        }),
      );
      await queryRunner.manager.save(orderItems);

      // ✅ Commit transaction
      await queryRunner.commitTransaction();

      return { user: savedUser, order: savedOrder, items: orderItems };
    } catch (error) {
      // ❌ Rollback nếu có lỗi
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
