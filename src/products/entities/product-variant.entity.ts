import {
    Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn,
    OneToOne, OneToMany, ManyToOne, JoinColumn, Index
} from 'typeorm';
import { ProductVariantInventory } from './product-variant-inventory.entity';
import { ProductVariantPrice } from './product-variant-price.entity';
import { ProductVariantRentalPrice } from './product-variant-rental-price.entity';
import { ProductVariantRental } from './product-variant-rental.entity';
import { Product } from './product.entity';
import { OrderItem } from 'src/orders/entities/order-item.entity';

export type SpecItem = {
    key: string; label: string; value: string;
    unit?: string | null;
    type?: 'text' | 'number' | 'boolean';
    group?: string | null;
    note?: string | null;
    order?: number;
};

@Entity('product_variants')
export class ProductVariant {
    @PrimaryGeneratedColumn({ name: 'variant_id' })
    variantId: number;

    @Index()
    @Column({ name: 'product_id', type: 'int' })
    productId: number;

    @Column({ name: 'variant_name', length: 255 })
    variantName: string;

    // unique khi NOT NULL (partial unique index)
    @Index('uq_product_variants_sku_not_null', { unique: true, where: 'sku IS NOT NULL' })
    @Column({ length: 50, nullable: true })
    sku?: string;

    @Index('uq_product_variants_barcode_not_null', { unique: true, where: 'barcode IS NOT NULL' })
    @Column({ length: 64, nullable: true })
    barcode?: string;

    @Column({ default: 1 })
    status: number;

    @Column({ name: 'attributes', type: 'jsonb', nullable: false, default: () => `'{}'::jsonb` })
    attributes: Record<string, any>;



    @CreateDateColumn({ name: 'created_at' }) createdAt: Date;
    @UpdateDateColumn({ name: 'updated_at' }) updatedAt: Date;

    @OneToOne(() => ProductVariantInventory, (inventory) => inventory.variant, { cascade: true })
    inventory: ProductVariantInventory;

    @OneToMany(() => ProductVariantPrice, (price) => price.variant, { cascade: true })
    prices: ProductVariantPrice[];

    @OneToMany(() => ProductVariantRentalPrice, (rp) => rp.variant, { cascade: true })
    rentalPrices: ProductVariantRentalPrice[];

    @OneToMany(() => ProductVariantRental, (r) => r.variant, { cascade: true })
    rentals: ProductVariantRental[];

    @ManyToOne(() => Product, (product) => product.variants, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'product_id' })
    product: Product;

    @Column({ name: 'image_url', type: 'text', nullable: true })
    imageUrl?: string | null;

    // ✅ Quan trọng: inverse side tới OrderItem.variant
    @OneToMany(() => OrderItem, (item) => item.variant)
    orderItems: OrderItem[];

    @Column({ name: 'specs', type: 'jsonb', nullable: false, default: () => `'[]'::jsonb` })
    specs: SpecItem[];
}
