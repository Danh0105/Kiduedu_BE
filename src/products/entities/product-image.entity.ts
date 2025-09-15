import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Product } from './product.entity';

@Entity('product_images')
export class ProductImage {
  @PrimaryGeneratedColumn()
  image_id: number;

  @ManyToOne(() => Product, product => product.images, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;


  @Column({ length: 255 })
  image_url: string;

  @Column({ length: 255, nullable: true })
  alt_text: string;

  @Column({ default: false })
  is_primary: boolean;
}
