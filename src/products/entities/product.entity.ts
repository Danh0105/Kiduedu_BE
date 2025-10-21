// src/products/entities/product.entity.ts
import {
  Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany,
  PrimaryGeneratedColumn, UpdateDateColumn, RelationId
} from 'typeorm';
import { Category } from '../../categories/entities/category.entity';
import { ProductImage } from './product-image.entity';
import { OrderItem } from '../../orders/entities/order-item.entity';
import { ProductVariant } from './product-variant.entity';

// (tuỳ chọn) transformer cho numeric -> number
const numericToNumber = {
  to: (v?: number | null) => v ?? null,
  from: (v?: string | null) => (v != null ? Number(v) : null),
};

@Entity('products')
export class Product {
  @PrimaryGeneratedColumn() product_id: number;

  @Column({ length: 255 }) product_name: string;

  @Column({ length: 50, unique: true, nullable: true }) sku: string;

  @Column({ type: 'text', nullable: true }) long_description: string | null;

  @Column({ type: 'text', nullable: true }) short_description: string | null;

  @Column({ type: 'int', default: 1 }) status: number;

  @Column({ type: 'numeric', precision: 12, scale: 2, transformer: numericToNumber })
  price: number;

  @Column({ type: 'int', default: 0 }) stock_quantity: number;

  @ManyToOne(() => Category, (c) => c.products, { onDelete: 'RESTRICT', onUpdate: 'CASCADE', nullable: true })
  @JoinColumn({ name: 'category_id' })
  category?: Category | null;

  @RelationId((p: Product) => p.category)
  category_id?: number | null;

  @CreateDateColumn({ type: 'timestamp without time zone', default: () => 'NOW()' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamp without time zone', default: () => 'NOW()' })
  updated_at: Date;

  @Column({ name: 'specs', type: 'jsonb', nullable: false })
  specs: Record<string, any>;

  // origin: text, cho phép null
  @Column({ name: 'origin', type: 'text', nullable: true })
  origin: string | null;

  // user_manual: JSONB, CHO PHÉP NULL
  @Column({ name: 'user_manual', type: 'jsonb', nullable: true })
  user_manual: { pdf?: string; video?: string; steps?: string[] } | null;


  // caution_notes: jsonb, default [], NOT NULL
  @Column({ name: 'caution_notes', type: 'jsonb', nullable: false, default: () => `'[]'::jsonb` })
  caution_notes: string[];


  @Column({ type: 'tsvector', select: false, insert: false, update: false, nullable: true })
  search_vec: any;

  @OneToMany(() => ProductImage, (img) => img.product, { cascade: true, onDelete: 'CASCADE' })
  images: ProductImage[];

  @OneToMany(() => OrderItem, (item) => item.product)
  orderItems: OrderItem[];

  @OneToMany(() => ProductVariant, (v) => v.product)
  variants: ProductVariant[];
}