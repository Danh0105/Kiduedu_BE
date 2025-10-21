import {
    Column, CreateDateColumn, Entity, Index, JoinColumn, ManyToOne,
    PrimaryGeneratedColumn, UpdateDateColumn
} from 'typeorm';
import { Product } from './product.entity';

@Entity({ name: 'product_variants' })
@Index('idx_product_variants_product_id', ['productId'])
@Index('idx_product_variants_status', ['status'])
export class ProductVariant {
    @PrimaryGeneratedColumn({ name: 'variant_id' })
    variantId: number;

    @Column({ name: 'product_id', type: 'int' })
    productId: number;

    @ManyToOne(() => Product, p => p.variants, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'product_id' })
    product: Product;

    @Column({ name: 'variant_name', type: 'varchar', length: 255 })
    variantName: string;

    @Column({ name: 'sku', type: 'varchar', length: 50, nullable: true, unique: true })
    sku?: string;

    @Column({ name: 'barcode', type: 'varchar', length: 64, nullable: true })
    barcode?: string;

    @Column({ name: 'attributes', type: 'jsonb', default: () => `'{}'::jsonb` })
    attributes: Record<string, any>;

    @Column({ name: 'status', type: 'int', default: 1 })
    status: number; // 1 = active, 0 = inactive

    @CreateDateColumn({ name: 'created_at', type: 'timestamp without time zone' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at', type: 'timestamp without time zone' })
    updatedAt: Date;
}
