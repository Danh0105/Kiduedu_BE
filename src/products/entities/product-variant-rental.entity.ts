// src/modules/products/entities/product-variant-rental.entity.ts
import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, ManyToOne, JoinColumn, UpdateDateColumn } from 'typeorm';
import { ProductVariant } from './product-variant.entity';

@Entity({ name: 'product_variant_rentals' })
export class ProductVariantRental {
    @PrimaryGeneratedColumn()
    rentalId: number;

    @Column()
    variantId: number;

    @ManyToOne(() => ProductVariant, (variant) => variant.rentals, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'variantId' })
    variant: ProductVariant;

    @Column()
    userId: number;

    @Column({ type: 'varchar', length: 20 })
    rentalType: 'daily' | 'weekly' | 'monthly';

    @Column({ type: 'date' })
    startDate: string;

    @Column({ type: 'date' })
    endDate: string;

    @Column({ type: 'decimal', precision: 12, scale: 2 })
    totalPrice: number;

    @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 })
    depositPaid: number;

    @Column({ type: 'varchar', length: 20, default: 'pending' })
    status: 'pending' | 'active' | 'completed' | 'cancelled';

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn()
    updatedAt: Date;
}
