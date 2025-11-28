// src/products/entities/product-image.entity.ts

import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Product } from './product.entity';

@Entity('product_images')
export class ProductImage {
  @PrimaryGeneratedColumn({ name: 'image_id' })
  imageId: number;

  @Column({ name: 'image_url', type: 'varchar', nullable: false })
  imageUrl: string;

  @Column({ name: 'alt_text', type: 'varchar', nullable: true })
  altText?: string;  // NOT null — chỉ undefined

  @Column({ name: 'is_primary', type: 'boolean', default: false })
  isPrimary: boolean;

  // FE gửi: public_id
  // Entity: publicId
  // DB: public_id
  @Column({ name: 'public_id', type: 'varchar', nullable: true })
  publicId?: string;

  @ManyToOne(() => Product, product => product.images, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;
}
