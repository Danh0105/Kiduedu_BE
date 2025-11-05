// src/modules/products/entities/product-variant-rental-price.entity.ts
import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, ManyToOne, JoinColumn } from 'typeorm';
import { ProductVariant } from './product-variant.entity';

@Entity({ name: 'product_variant_rental_prices' })
export class ProductVariantRentalPrice {
    @PrimaryGeneratedColumn()
    rentalPriceId: number;

    @Column()
    variantId: number;

    @ManyToOne(() => ProductVariant, (variant) => variant.rentalPrices, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'variantId' })
    variant: ProductVariant;

    @Column({ type: 'varchar', length: 20 })
    rentalType: 'daily' | 'weekly' | 'monthly';

    @Column({ type: 'decimal', precision: 12, scale: 2 })
    price: number;

    @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 })
    deposit: number;

    @Column({ type: 'char', length: 3, default: 'VND' })
    currencyCode: string;

    @CreateDateColumn()
    createdAt: Date;
}
