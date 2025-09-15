import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, CreateDateColumn, UpdateDateColumn, JoinColumn } from 'typeorm';
import { Category } from '../../categories/entities/category.entity';
import { ProductImage } from './product-image.entity';
import { ProductAttributeValue } from '../../products/entities/product-attribute-value.entity';
import { OrderItem } from '../../orders/entities/order-item.entity';

@Entity('products')
export class Product {
  @PrimaryGeneratedColumn()
  product_id: number;

  @Column({ length: 255 })
  product_name: string;

  @Column({ length: 50, unique: true })
  sku: string;

  @Column({ type: 'text', nullable: true })
  long_description: string;

  @Column({ type: 'text', nullable: true })
  short_description: string;

  @Column({ type: 'int', default: 1 })
  status: number;

  @Column({ type: 'decimal', precision: 12, scale: 2 })
  price: number;

  @Column({ type: 'int', default: 0 })
  stock_quantity: number;

  @ManyToOne(() => Category, category => category.products, { onDelete: 'RESTRICT' })
  @JoinColumn({ name: 'category_id' })
  category: Category;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @OneToMany(() => ProductImage, image => image.product, { cascade: true })
  images: ProductImage[];

  @OneToMany(() => ProductAttributeValue, attrValue => attrValue.product)
  attributeValues: ProductAttributeValue[];

  @OneToMany(() => OrderItem, item => item.product)
  orderItems: OrderItem[];
}
