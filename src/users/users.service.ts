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
import { Product } from 'src/products/entities/product.entity'; // <-- đảm bảo import đúng path

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

  async createUser(data: {
    username: string;
    email: string;
    role?: string;
    customerType?: CustomerType; // nếu không truyền => mặc định INDIVIDUAL
    companyName?: string;
    taxId?: string;
    businessEmail?: string;
    fullName?: string;
    dateOfBirth?: string; // YYYY-MM-DD
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
      const mgr = queryRunner.manager;
      const customerType = data.customerType ?? CustomerType.INDIVIDUAL;

      // 1) Tìm user theo email (ngoài transaction cũng được, nhưng để đồng nhất thì dùng mgr)
      let savedUser = await mgr.getRepository(User).findOne({
        where: { email: data.email },
        relations: ['cart', 'addresses'],
      });

      // 2) Nếu chưa có user -> tạo mới (toàn bộ bằng mgr)
      if (!savedUser) {
        const user = mgr.create(User, {
          username: data.username,
          email: data.email,
          role: data.role ?? 'customer',
          customer_type: customerType,
        });
        savedUser = await mgr.save(user);

        // Cart
        const cart = mgr.create(Cart, { user: savedUser });
        await mgr.save(cart);

        // Address
        if (data.address) {
          const address = mgr.create(Address, { ...data.address, user: savedUser });
          await mgr.save(address);
        }

        // Profile
        if (customerType === CustomerType.BUSINESS) {
          const businessProfile = mgr.create(UserProfileBusiness, {
            user: savedUser, // truyền entity, mgr sẽ gán user_id đúng
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

      // 3) Validate danh sách product trước khi tạo order items
      const productIds = (data.items ?? []).map(i => i.product_id);
      if (productIds.length === 0) {
        throw new BadRequestException('Items must not be empty');
      }

      const productRepo = mgr.getRepository(Product);
      const products = await productRepo.find({
        where: { product_id: In(productIds) },
        select: ['product_id', 'price', 'product_name'],
      });

      const foundIds = new Set(products.map(p => p.product_id));
      const missing = productIds.filter(id => !foundIds.has(id));

      if (missing.length > 0) {
        throw new BadRequestException(`Product(s) not found: ${missing.join(', ')}`);
      }

      // 4) Tính toán order
      const subtotal = data.items.reduce(
        (sum, i) => sum + Number(i.price_per_unit) * Number(i.quantity),
        0,
      );
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

      // 5) Tạo order items (liên kết product bằng entity đã load để chắc chắn qua FK)
      const itemsEntities = data.items.map(i => {
        const product = products.find(p => p.product_id === i.product_id)!;
        return mgr.create(OrderItem, {
          order: savedOrder,
          product, // pass entity product để FK chắc chắn đúng
          quantity: i.quantity,
          price_per_unit: i.price_per_unit,
        });
      });

      const savedItems = await mgr.save(itemsEntities);

      // 6) Commit
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
