// src/orders/entities/order.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  OneToMany,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { OrderItem } from './order-item.entity';
import { User } from '../../users/entities/user.entity';
import { Promotion } from '../../promotions/entities/promotion.entity';
import { Address } from 'src/users/entities/address.entity';

@Entity('orders')
export class Order {
  @PrimaryGeneratedColumn({ name: 'order_id' })
  orderId: number;

  @Column({
    name: 'subtotal',
    type: 'numeric',
    precision: 15,
    scale: 2,
    transformer: {
      to: (v: number) => v,
      from: (v: string) => Number(v),
    },
  })
  subtotal: number;

  @Column({
    name: 'discount_amount',
    type: 'numeric',
    precision: 15,
    scale: 2,
    default: 0,
    transformer: {
      to: (v: number) => v,
      from: (v: string) => Number(v),
    },
  })
  discountAmount: number;

  @Column({
    name: 'total_amount',
    type: 'numeric',
    precision: 15,
    scale: 2,
    transformer: {
      to: (v: number) => v,
      from: (v: string) => Number(v),
    },
  })
  totalAmount: number;


  @Column({
    name: 'status',
    type: 'varchar',
    default: 'Pending',
  })
  status: string;

  @Column({
    name: 'order_date',
    type: 'timestamptz',
    default: () => 'now()',
  })
  orderDate: Date;

  @Column({ name: 'user_id', type: 'int', nullable: true })
  userId: number | null;

  @Column({ name: 'promotion_id', type: 'int', nullable: true })
  promotionId: number | null;

  // ====== Quan hệ ======

  @ManyToOne(() => User, (user) => user.orders, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'user_id' })
  user?: User | null;

  @ManyToOne(() => Promotion, (promo) => promo.orders, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'promotion_id' })
  promotion?: Promotion | null;

  @OneToMany(() => OrderItem, (item) => item.order)
  items: OrderItem[];
  @ManyToOne(() => Address, { nullable: true, eager: true })
  @JoinColumn({ name: 'shipping_address_id' })
  shippingAddress?: Address | null;

  @Column({ name: 'shipping_address_id', type: 'int', nullable: true })
  shippingAddressId: number | null;
}
