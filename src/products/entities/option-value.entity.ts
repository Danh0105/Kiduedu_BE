import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { ProductVariantOptionValue } from './product-variant-option-value.entity';

@Entity('option_values')
export class OptionValue {
  @PrimaryGeneratedColumn({ name: 'option_value_id' })
  optionValueId: number;

  @Column({ name: 'option_type_id' })
  optionTypeId: number;

  @Column({ length: 100 })
  value: string;

  @Column({ nullable: true })
  position: number;

  // ✅ Quan hệ ngược lại: 1 option value có thể thuộc nhiều variant
  @OneToMany(() => ProductVariantOptionValue, (pvo) => pvo.optionValue)
  variantLinks: ProductVariantOptionValue[];
}
