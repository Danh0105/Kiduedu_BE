import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, CreateDateColumn, UpdateDateColumn, JoinColumn } from 'typeorm';
import { Category } from '../../categories/entities/category.entity';
import { ProductImage } from './product-image.entity';
import { ProductAttributeValue } from '../../products/entities/product-attribute-value.entity';
import { OrderItem } from '../../orders/entities/order-item.entity';

@Entity('products')
export class Product {
  @PrimaryGeneratedColumn()
  product_id: number;

  @Column({ length: 255, nullable: false })
  product_name: string;

  @Column({ length: 50, unique: true, nullable: false })
  sku: string;

  @Column({ type: 'text', nullable: true })
  long_description: string;

  @Column({ type: 'text', nullable: true })
  short_description: string;

  @Column({ type: 'int', default: 1, nullable: false })
  status: number;

  @Column({ type: 'decimal', precision: 12, scale: 2, nullable: false })
  price: number;

  @Column({ type: 'int', default: 0, nullable: false })
  stock_quantity: number;

  @ManyToOne(() => Category, category => category.products, {
    onDelete: 'RESTRICT',
    onUpdate: 'CASCADE',
    nullable: false,
  })
  @JoinColumn({ name: 'category_id' })
  category: Category;

  @CreateDateColumn({ type: 'timestamp without time zone', default: () => 'NOW()', nullable: false })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamp without time zone', default: () => 'NOW()', nullable: false })
  updated_at: Date;

  // ✅ Cột SPECS (đã bổ sung trước đó)
  @Column({ type: 'jsonb', nullable: true })
  specs: any;

  // ✅ Cột ORIGIN (mới bổ sung để tránh lỗi)
  // Dựa trên hình ảnh DB trước đó, 'origin' có kiểu 'text' và nullable
  @Column({ type: 'text', nullable: true })
  origin: string;

  @Column({ type: 'text', nullable: true })
  user_manual: string;

  @Column({ type: 'text', nullable: true })
  caution_notes: string;

  // ✅ Cột SEARCH_VEC (đã bổ sung trước đó)
  @Column({ type: 'tsvector', select: false, insert: false, update: false, nullable: true })
  search_vec: any;


  @OneToMany(() => ProductImage, image => image.product, { cascade: true, onDelete: 'CASCADE' })
  images: ProductImage[];

  @OneToMany(() => ProductAttributeValue, attrValue => attrValue.product, { cascade: true })
  attributeValues: ProductAttributeValue[];

  @OneToMany(() => OrderItem, item => item.product)
  orderItems: OrderItem[];
}