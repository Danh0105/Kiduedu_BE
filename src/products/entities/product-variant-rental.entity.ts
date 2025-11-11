// src/modules/products/entities/product-variant-rental.entity.ts
import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, ManyToOne, JoinColumn, UpdateDateColumn } from 'typeorm';
import { ProductVariant } from './product-variant.entity';


@Entity({ name: 'product_variant_rentals' })
export class ProductVariantRental {
    @PrimaryGeneratedColumn({ name: 'rental_id' })
    rentalId: number;

    @Column({ name: 'variant_id' })
    variantId: number;

    @ManyToOne(() => ProductVariant, (variant) => variant.rentals, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'variant_id' })
    variant: ProductVariant;

    @Column({ name: 'rental_type', type: 'varchar', length: 20 })
    rentalType: 'daily' | 'weekly' | 'monthly';

    @Column({ name: 'start_date', type: 'date' })
    startDate: string;

    @Column({ name: 'end_date', type: 'date' })
    endDate: string;

    @Column({ name: 'total_price', type: 'decimal', precision: 12, scale: 2 })
    totalPrice: number;

    @Column({ name: 'deposit_paid', type: 'decimal', precision: 12, scale: 2, default: 0 })
    depositPaid: number;

    @Column({ type: 'varchar', length: 20, default: 'pending' })
    status: 'pending' | 'active' | 'completed' | 'cancelled';

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at' })
    updatedAt: Date;
}
