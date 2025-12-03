import {
  Entity,
  PrimaryColumn,
  Column,
  UpdateDateColumn,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { ProductVariant } from './product-variant.entity';

@Entity('product_variant_inventory')
export class ProductVariantInventory {
  // Dùng luôn variantId làm PK
  @PrimaryColumn({ name: 'variant_id', type: 'int' })
  variantId: number;

  @Column({ name: 'stock_quantity', type: 'int', default: 0 })
  stock_quantity: number;

  @Column({ name: 'safety_stock', type: 'int', default: 0 })
  safety_stock: number;

  @UpdateDateColumn({ name: 'updated_at' })
  updated_at: Date;

  @OneToOne(() => ProductVariant, (variant) => variant.inventory, {
    onDelete: 'CASCADE',
  })
  @OneToOne(() => ProductVariant, (variant) => variant.inventory)
  @JoinColumn({ name: "variant_id" })
  variant: ProductVariant;
}
