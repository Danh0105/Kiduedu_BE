import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
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
import { ProductVariant } from './product-variant.entity';



@Entity({ name: 'products' })
export class Product {
  /** 🔑 Khóa chính */
  @PrimaryGeneratedColumn({ name: 'product_id' })
  productId: number;

  /** 🏷️ Tên sản phẩm */
  @Column({ name: 'product_name', type: 'varchar', length: 255 })
  productName: string;

  /** ✏️ Mô tả ngắn */
  @Column({ name: 'short_description', type: 'text', nullable: true })
  shortDescription?: string | null;

  /** 📄 Mô tả chi tiết */
  @Column({ name: 'long_description', type: 'text', nullable: true })
  longDescription?: string | null;

  /** ⚙️ Trạng thái: 1=active, 0=inactive */
  @Column({ name: 'status', type: 'int', default: 1 })
  status: number;

  /** 🌍 Xuất xứ */
  @Column({ name: 'origin', type: 'text', nullable: true })
  origin?: string | null;

  /** 📘 HDSD: object JSONB { pdf?: string; video?: string; steps?: string[] } */
  @Column({ name: 'user_manual', type: 'jsonb', nullable: true })
  userManual?: { pdf?: string; video?: string; steps?: string[] } | null;

  /** ⚠️ Cảnh báo an toàn (JSONB mảng string) */
  @Column({
    name: 'caution_notes',
    type: 'jsonb',
    nullable: false,
    default: () => `'[]'::jsonb`,
  })
  cautionNotes: string[];

  /** 🔍 Vector tìm kiếm toàn văn (điền qua trigger/materialized column) */
  @Column({
    name: 'search_vec',
    type: 'tsvector',
    select: false,
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
  @Column({ name: 'category_id', type: 'int', nullable: true })
  categoryId?: number | null;

  /** 🖼️ Ảnh sản phẩm (1-N) */
  @OneToMany(() => ProductImage, (img) => img.product, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  images: ProductImage[];

  /** 📦 Biến thể (nếu còn dùng: chỉ chứa thông tin thương mại như SKU/giá/tồn kho) */
  @OneToMany(() => ProductVariant, (v) => v.product, { cascade: true })
  variants?: ProductVariant[] | null;

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

  @Column({ name: 'price', type: 'decimal', precision: 12, scale: 2 })
  price: number;

}
