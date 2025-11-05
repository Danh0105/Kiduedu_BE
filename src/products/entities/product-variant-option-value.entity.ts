import { Entity, ManyToOne, JoinColumn, PrimaryGeneratedColumn, Column } from 'typeorm';
import { ProductVariant } from './product-variant.entity';
import { OptionValue } from './option-value.entity';

@Entity('product_variant_option_values')
export class ProductVariantOptionValue {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'variant_id' })
  variantId: number;

  @Column({ name: 'option_value_id' })
  optionValueId: number;

  @ManyToOne(() => ProductVariant, (variant) => variant.optionValues, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'variant_id' })
  variant: ProductVariant;

  @ManyToOne(() => OptionValue, (optionValue) => optionValue.variantLinks, {
    eager: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'option_value_id' })
  optionValue: OptionValue;
}
