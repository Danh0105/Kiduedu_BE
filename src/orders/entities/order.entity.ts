import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, JoinColumn, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Promotion } from '../../promotions/entities/promotion.entity';
import { OrderItem } from './order-item.entity';

@Entity('orders')
export class Order {
  @PrimaryGeneratedColumn()
  order_id: number;

  @ManyToOne(() => User, user => user.orders, { onDelete: 'RESTRICT' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @CreateDateColumn()
  order_date: Date;

  @Column({ default: 'Pending' })
  status: string;

  @Column({ type: 'text' })
  shipping_address: string;

  @Column({ type: 'decimal', precision: 15, scale: 2 })
  subtotal: number;

  @Column({ type: 'decimal', precision: 15, scale: 2, default: 0 })
  discount_amount: number;

  @Column({ type: 'decimal', precision: 15, scale: 2 })
  total_amount: number;

  @ManyToOne(() => Promotion, promotion => promotion.orders, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'promotion_id' })
  promotion: Promotion;

  @OneToMany(() => OrderItem, item => item.order)
  orderItems: OrderItem[];
}
