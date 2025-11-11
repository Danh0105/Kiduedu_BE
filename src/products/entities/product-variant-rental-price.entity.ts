// src/modules/products/entities/product-variant-rental-price.entity.ts
import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, ManyToOne, JoinColumn, UpdateDateColumn } from 'typeorm';
import { ProductVariant } from './product-variant.entity';

@Entity({ name: 'product_variant_rental_prices' })
export class ProductVariantRentalPrice {
    @PrimaryGeneratedColumn({ name: 'rental_price_id' })
    rentalPriceId: number;

    @Column({ name: 'variant_id' })
    variantId: number;

    @ManyToOne(() => ProductVariant, (variant) => variant.rentalPrices, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'variant_id' })
    variant: ProductVariant;

    @Column({ name: 'rental_type', type: 'varchar', length: 20 })
    rentalType: 'daily' | 'weekly' | 'monthly';

    @Column({ type: 'decimal', precision: 12, scale: 2 })
    price: number;

    @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 })
    deposit: number;

    @Column({ name: 'currency_code', type: 'char', length: 3, default: 'VND' })
    currencyCode: string;

    @Column({ name: 'start_at' })
    startDate: Date;

    @Column({ name: 'end_at' })
    endDate: Date;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

}
