import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { ProductVariant } from './product-variant.entity';

@Entity('product_variant_inventory')
export class ProductVariantInventory {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  variant_id: number;

  @Column({ default: 0 })
  stock_quantity: number;

  @Column({ default: 0 })
  safety_stock: number;

  @Column({ type: 'timestamp', default: () => 'now()' })
  updated_at: Date;

  // ✅ Sửa lại mối quan hệ thành OneToOne
  @OneToOne(() => ProductVariant, (variant) => variant.inventory, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'variant_id' })
  variant: ProductVariant;
}
