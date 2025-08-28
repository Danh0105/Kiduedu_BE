import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import { Product } from '../../products/entities/product.entity';
import { CategoryAttribute } from 'src/products/entities/category-attribute.entity';

@Entity('categories')
export class Category {
  @PrimaryGeneratedColumn()
  category_id: number;

  @Column({ length: 100 })
  category_name: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @ManyToOne(() => Category, category => category.children, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'parent_category_id' })
  parent: Category;

  @OneToMany(() => Category, category => category.parent)
  children: Category[];

  @OneToMany(() => Product, product => product.category)
  products: Product[];

  @OneToMany(() => CategoryAttribute, (ca) => ca.category)
  categoryAttributes: CategoryAttribute[];

}
