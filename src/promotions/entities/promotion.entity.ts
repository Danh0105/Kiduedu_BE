import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { PromotionApplicability } from './promotion-applicability.entity';
import { Order } from '../../orders/entities/order.entity';

@Entity('promotions')
export class Promotion {
  @PrimaryGeneratedColumn()
  promotion_id: number;

  @Column({ length: 100 })
  name: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'enum', enum: ['percentage', 'fixed_amount'] })
  discount_type: 'percentage' | 'fixed_amount';

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  discount_value: number;

  @Column({ type: 'timestamptz' })
  start_date: Date;

  @Column({ type: 'timestamptz' })
  end_date: Date;

  @Column({ default: true })
  is_active: boolean;

  @OneToMany(() => PromotionApplicability, pa => pa.promotion)
  applicability: PromotionApplicability[];

  @OneToMany(() => Order, order => order.promotion)
  orders: Order[];
}
