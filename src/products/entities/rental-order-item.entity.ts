// src/modules/rental-orders/entities/rental-order-item.entity.ts
import {
    Column,
    CreateDateColumn,
    Entity,
    Index,
    JoinColumn,
    ManyToOne,
    PrimaryGeneratedColumn,
    UpdateDateColumn,
} from 'typeorm';
import { RentalOrder } from './rental-order.entity';
import { ProductVariant } from '../entities/product-variant.entity';

// (tuỳ chọn) transformer cho numeric -> number
class NumericTransformer {
    to(value?: number | null) { return value as any; }
    from(value?: string | null) { return typeof value === 'string' ? parseFloat(value) : (value as any); }
}

@Entity({ name: 'rental_order_items' })
export class RentalOrderItem {
    @PrimaryGeneratedColumn({ type: 'integer' })
    id!: number;

    /** FK -> rental_orders.id_rental_order */
    @Index()
    @Column({ name: 'rental_order_id', type: 'integer' })
    rentalOrderId!: number;

    /** FK -> product_variants.variant_id (thuộc tính entity: variantId) */
    @Index()
    @Column({ name: 'variant_id', type: 'integer' })
    variantId!: number;

    @Column({ name: 'rental_type', type: 'varchar', length: 20, nullable: true })
    rentalType?: string | null;

    @Column({
        name: 'price',
        type: 'numeric',
        precision: 12,
        scale: 2,
        transformer: new NumericTransformer(),
    })
    price!: number;

    @Column({
        name: 'deposit',
        type: 'numeric',
        precision: 12,
        scale: 2,
        default: 0,
        transformer: new NumericTransformer(),
    })
    deposit!: number;

    @Column({ name: 'quantity', type: 'integer', default: 1 })
    quantity!: number;

    @Column({ name: 'start_date', type: 'date', nullable: true })
    startDate?: string | null;

    @Column({ name: 'end_date', type: 'date', nullable: true })
    endDate?: string | null;

    @Column({ name: 'returned_at', type: 'date', nullable: true })
    returnedAt?: string | null;

    @Column({ name: 'return_status', type: 'varchar', length: 20, nullable: true })
    returnStatus?: string | null;

    @CreateDateColumn({ name: 'created_at', type: 'timestamp without time zone' })
    createdAt!: Date;

    @UpdateDateColumn({ name: 'updated_at', type: 'timestamp without time zone' })
    updatedAt!: Date;

    // ------- Relations --------

    /** rental_order_items.rental_order_id -> rental_orders.id_rental_order */
    @ManyToOne(() => RentalOrder, (o) => o.items, {
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
    })
    @JoinColumn({ name: 'rental_order_id', referencedColumnName: 'id_rental_order' })
    order!: RentalOrder;

    /** rental_order_items.variant_id -> product_variants.variant_id (entity prop: variantId) */
    @ManyToOne(() => ProductVariant, (v) => v.rentals, {
        onDelete: 'RESTRICT',
        onUpdate: 'CASCADE',
    })
    @JoinColumn({ name: 'variant_id', referencedColumnName: 'variantId' })
    variant!: ProductVariant;
}
