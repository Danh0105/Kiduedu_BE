import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from 'typeorm';
import { OptionType } from './option-type.entity';
import { ProductVariantOptionValue } from './product-variant-option-value.entity';

@Entity({ name: 'option_values' })
export class OptionValue {
  @PrimaryGeneratedColumn({ name: 'option_value_id' })
  optionValueId: number;

  @Column({ name: 'option_type_id', type: 'integer' })
  optionTypeId: number;

  @Column({ type: 'varchar', length: 100 })
  value: string;

  @Column({ type: 'integer', default: 0 })
  position: number;

  @ManyToOne(() => OptionType, (optionType) => optionType.optionValues, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'option_type_id' })
  optionType: OptionType;
  @OneToMany(
    () => ProductVariantOptionValue,
    (optionLink) => optionLink.optionValue,
    { cascade: true },
  )
  variantOptionLinks: ProductVariantOptionValue[];

}
