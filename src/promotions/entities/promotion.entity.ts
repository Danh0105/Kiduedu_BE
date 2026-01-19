import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { PromotionApplicability } from './promotion-applicability.entity';
import { Order } from '../../orders/entities/order.entity';

@Entity('promotions')
export class Promotion {
  @PrimaryGeneratedColumn({ name: 'promotion_id' })
  id: number;

  @Column({ length: 100 })
  name: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({
    name: 'discount_type',
    type: 'enum',
    enum: ['percentage', 'fixed_amount'],
  })
  discountType: 'percentage' | 'fixed_amount';

  @Column({
    name: 'discount_value',
    type: 'decimal',
    precision: 10,
    scale: 2,
  })
  discountValue: number;

  @Column({ name: 'start_date', type: 'timestamptz' })
  startDate: Date;

  @Column({ name: 'end_date', type: 'timestamptz' })
  endDate: Date;

  @Column({ name: 'is_active', default: true })
  isActive: boolean;

  @OneToMany(() => PromotionApplicability, pa => pa.promotion)
  applicability: PromotionApplicability[];

  @OneToMany(() => Order, order => order.promotion)
  orders: Order[];
  // ================= VOUCHER =================

  /** 🎟️ Mã voucher (null = không phải voucher) */
  @Column({ name: 'code', type: 'varchar', length: 50, unique: true, nullable: true })
  code?: string | null;

  /** 🔢 Số lượt sử dụng tối đa */
  @Column({ name: 'usage_limit', type: 'int', nullable: true })
  usageLimit?: number | null;

  /** 🔢 Đã sử dụng bao nhiêu lần */
  @Column({ name: 'used_count', type: 'int', default: 0 })
  usedCount: number;

  /** 💰 Giá trị đơn hàng tối thiểu */
  @Column({ name: 'min_order_value', type: 'decimal', precision: 12, scale: 2, nullable: true })
  minOrderValue?: number | null;

  /** 🚫 Chỉ cho phép dùng 1 voucher / đơn */
  @Column({ name: 'is_voucher', default: false })
  isVoucher: boolean;
}
