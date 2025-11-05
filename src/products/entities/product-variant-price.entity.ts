import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { ProductVariant } from './product-variant.entity';

@Entity('product_variant_prices')
export class ProductVariantPrice {
  @PrimaryGeneratedColumn({ name: 'price_id' })
  priceId: number;

  @Column({ name: 'variant_id' })
  variantId: number;

  @Column({ name: 'price_type', length: 50 })
  priceType: string;

  @Column({ name: 'currency_code', length: 3, default: 'VND' })
  currencyCode: string;

  @Column({ type: 'numeric', precision: 12, scale: 2 })
  price: number;

  @Column({ name: 'start_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  startAt: Date;

  @Column({ name: 'end_at', type: 'timestamp', nullable: true })
  endAt: Date | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;


  @ManyToOne(() => ProductVariant, (variant) => variant.prices, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'variant_id' })
  variant: ProductVariant;

}
