import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
    OneToOne,
    OneToMany,
    ManyToOne,
    JoinColumn,
} from 'typeorm';
import { ProductVariantInventory } from './product-variant-inventory.entity';
import { ProductVariantOptionValue } from './product-variant-option-value.entity';
import { ProductVariantPrice } from './product-variant-price.entity';
import { ProductVariantRentalPrice } from './product-variant-rental-price.entity';
import { ProductVariantRental } from './product-variant-rental.entity';
import { Product } from './product.entity';
import { OrderItem } from 'src/orders/entities/order-item.entity';

@Entity('product_variants')
export class ProductVariant {
    // ✅ fix lỗi ở đây
    @PrimaryGeneratedColumn({ name: 'variant_id' })
    variantId: number;

    @Column({ name: 'product_id' })
    productId: number;

    @Column({ name: 'variant_name', length: 255 })
    variantName: string;

    @Column({ length: 50, nullable: true })
    sku?: string;

    @Column({ length: 64, nullable: true })
    barcode?: string;

    @Column({ type: 'jsonb', default: '{}' })
    attributes: Record<string, any>;

    @Column({ default: 1 })
    status: number;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at' })
    updatedAt: Date;

    // ✅ Quan hệ 1-1 Inventory
    @OneToOne(() => ProductVariantInventory, (inventory) => inventory.variant, { cascade: true })
    inventory: ProductVariantInventory;

    // ✅ Quan hệ 1-n Option Values
    @OneToMany(() => ProductVariantOptionValue, (ov) => ov.variant, { cascade: true })
    optionValues: ProductVariantOptionValue[];

    // ✅ Quan hệ 1-n Prices
    @OneToMany(() => ProductVariantPrice, (price) => price.variant, { cascade: true })
    prices: ProductVariantPrice[];

    // ✅ Quan hệ 1-n Rental Prices
    @OneToMany(() => ProductVariantRentalPrice, (rp) => rp.variant, { cascade: true })
    rentalPrices: ProductVariantRentalPrice[];

    // ✅ Quan hệ 1-n Rentals
    @OneToMany(() => ProductVariantRental, (r) => r.variant, { cascade: true })
    rentals: ProductVariantRental[];

    // ✅ Quan hệ n-1 Product
    @ManyToOne(() => Product, (product) => product.variants, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'product_id' })
    product: Product;

    @Column({ name: 'image_url', type: 'text', nullable: true })
    imageUrl?: string | null;

    @OneToMany(() => OrderItem, (item) => item.variant)
    orderItems: OrderItem[];

}
