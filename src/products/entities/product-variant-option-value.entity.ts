import {
  Entity, ManyToOne, JoinColumn, PrimaryColumn, Column
} from 'typeorm';
import { Product } from './product.entity';
import { ProductVariant } from './product-variant.entity';
import { OptionValue } from './option-value.entity';

@Entity({ name: 'product_variant_option_values' })
export class ProductVariantOptionValue {

  @PrimaryColumn({ name: 'option_value_id', type: 'int' })
  optionValueId: number;

  @Column({ name: 'product_id', type: 'int' })
  productId: number;

  @ManyToOne(() => Product, { onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;


  @JoinColumn({ name: 'variant_id' })
  variant: ProductVariant;

  @ManyToOne(() => OptionValue, (ov) => ov.variantOptionLinks, {
    onDelete: 'CASCADE', onUpdate: 'CASCADE',
  })
  @JoinColumn({ name: 'option_value_id' })
  optionValue: OptionValue;
}
