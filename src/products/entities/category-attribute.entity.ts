import { Entity, PrimaryColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Category } from '../../categories/entities/category.entity';
import { Attribute } from './attribute.entity';

@Entity('category_attributes')
export class CategoryAttribute {
  @PrimaryColumn()
  category_id: number;

  @PrimaryColumn()
  attribute_id: number;

  @ManyToOne(() => Category, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'category_id' })
  category: Category;

  @ManyToOne(() => Attribute, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'attribute_id' })
  attribute: Attribute;
}
