import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import { Product } from '../../products/entities/product.entity';
import { CategoryAttribute } from 'src/products/entities/category-attribute.entity';

@Entity('categories')
export class Category {
  @PrimaryGeneratedColumn({ name: 'category_id' })
  category_id: number;

  @Column({ name: 'category_name', length: 100 })
  category_name: string;

  @Column({ name: 'description', type: 'text', nullable: true })
  description: string | null;

  @ManyToOne(() => Category, (category) => category.children, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'parent_category_id' })
  parent: Category | null;

  @OneToMany(() => Category, (category) => category.parent)
  children: Category[];

  @OneToMany(() => Product, (product) => product.category)
  products: Product[];

  @OneToMany(() => CategoryAttribute, (ca) => ca.category)
  categoryAttributes: CategoryAttribute[];
}
