import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  OneToMany,
  OneToOne,
} from 'typeorm';
import { Order } from '../../orders/entities/order.entity';
import { Cart } from '../../cart/entities/cart.entity';
import { Address } from './address.entity';
import { UserProfileIndividual } from './user_profile_individual.entity';
import { UserProfileBusiness } from './user_profile_business.entity';

export enum CustomerType {
  INDIVIDUAL = 'individual',
  BUSINESS = 'business',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  user_id: number;

  @Column({ unique: true, length: 50 })
  username: string;

  @Column({ unique: true, length: 100 })
  email: string;

  @Column({ length: 255, nullable: true })
  password_hash: string;

  @Column({ length: 100, nullable: true })
  full_name: string;

  @Column({ length: 20, nullable: true })
  phone_number: string;

  @Column({ default: 'customer' })
  role: string;

  @Column({ length: 255, nullable: true })
  images_url: string;

  @Column({ length: 255, nullable: true })
  address: string;

  @Column({
    type: 'enum',
    enum: CustomerType,
    default: CustomerType.INDIVIDUAL,
    nullable: true
  })
  customer_type: CustomerType;

  @Column({ length: 255, nullable: true })
  avatar_url: string;

  @CreateDateColumn()
  created_at: Date;

  // Quan hệ với đơn hàng
  @OneToMany(() => Order, order => order.user)
  orders: Order[];

  // Quan hệ với giỏ hàng
  @OneToOne(() => Cart, cart => cart.user)
  cart: Cart;

  // Quan hệ với danh sách địa chỉ
  @OneToMany(() => Address, address => address.user)
  addresses: Address[];

  // Hồ sơ cá nhân
  @OneToOne(() => UserProfileIndividual, profile => profile.user)
  profile_individual: UserProfileIndividual;

  // Hồ sơ doanh nghiệp
  @OneToOne(() => UserProfileBusiness, profile => profile.user)
  profile_business: UserProfileBusiness;
}
