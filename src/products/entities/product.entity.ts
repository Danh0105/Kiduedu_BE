import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  RelationId,
  UpdateDateColumn,
} from 'typeorm';
import { Category } from '../../categories/entities/category.entity';
import { ProductImage } from './product-image.entity';
import { OrderItem } from '../../orders/entities/order-item.entity';
import { ProductVariant } from './product-variant.entity';

@Entity({ name: 'products' })
export class Product {
  /** 🔑 Khóa chính */
  @PrimaryGeneratedColumn({ name: 'product_id' })
  productId: number;

  /** 🏷️ Tên sản phẩm */
  @Column({ name: 'product_name', length: 255 })
  productName: string;

  /** 📄 Mô tả chi tiết */
  @Column({ name: 'long_description', type: 'text', nullable: true })
  longDescription?: string | null;

  /** ✏️ Mô tả ngắn gọn */
  @Column({ name: 'short_description', type: 'text', nullable: true })
  shortDescription?: string | null;

  /** ⚙️ Trạng thái: 1=active, 0=inactive */
  @Column({ name: 'status', type: 'int', default: 1 })
  status: number;

  /** 🧾 Thông số kỹ thuật (JSONB) */
  @Column({ name: 'specs', type: 'jsonb', nullable: false, default: () => `'{}'::jsonb` })
  specs: Record<string, any>;

  /** 🌍 Xuất xứ (text) */
  @Column({ name: 'origin', type: 'text', nullable: true })
  origin?: string | null;

  /** 📘 Hướng dẫn sử dụng (có thể chứa PDF, video, hoặc bước hướng dẫn) */
  @Column({ name: 'user_manual', type: 'jsonb', nullable: true })
  userManual?: { pdf?: string; video?: string; steps?: string[] } | null;

  /** ⚠️ Ghi chú / cảnh báo an toàn */
  @Column({ name: 'caution_notes', type: 'jsonb', nullable: false, default: () => `'[]'::jsonb` })
  cautionNotes: string[];

  /** 🔍 Vector tìm kiếm (full-text search) */
  @Column({
    name: 'search_vec',
    type: 'tsvector',
    select: false,
    insert: false,
    update: false,
    nullable: true,
  })
  searchVec?: any;

  /** 🗂️ Danh mục sản phẩm */
  @ManyToOne(() => Category, (c) => c.products, {
    onDelete: 'RESTRICT',
    onUpdate: 'CASCADE',
    nullable: true,
  })
  @JoinColumn({ name: 'category_id' })
  category?: Category | null;

  @RelationId((p: Product) => p.category)
  categoryId?: number | null;

  /** 🖼️ Ảnh sản phẩm (quan hệ 1-N) */
  @OneToMany(() => ProductImage, (img) => img.product, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  images: ProductImage[];

  /** 📦 Danh sách biến thể (variants) */
  @OneToMany(() => ProductVariant, (v) => v.product, { cascade: true })
  variants: ProductVariant[];


  /** 🕒 Ngày tạo & cập nhật */
  @CreateDateColumn({
    name: 'created_at',
    type: 'timestamp without time zone',
    default: () => 'NOW()',
  })
  createdAt: Date;

  @UpdateDateColumn({
    name: 'updated_at',
    type: 'timestamp without time zone',
    default: () => 'NOW()',
  })
  updatedAt: Date;
}
