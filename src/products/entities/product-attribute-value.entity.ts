import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Product } from './product.entity';
import { Attribute } from './attribute.entity';

@Entity('product_attribute_values')
export class ProductAttributeValue {
  @PrimaryGeneratedColumn()
  value_id: number;

  @ManyToOne(() => Product, product => product.attributeValues, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;

  @ManyToOne(() => Attribute, attr => attr.productAttributeValues, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'attribute_id' })
  attribute: Attribute;

  @Column({ type: 'text', nullable: true })
  value_text: string;

  @Column({ type: 'decimal', precision: 18, scale: 4, nullable: true })
  value_number: number;

  @Column({ type: 'boolean', nullable: true })
  value_boolean: boolean;

  @Column({ type: 'date', nullable: true })
  value_date: Date;
}
