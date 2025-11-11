import {
    Column,
    CreateDateColumn,
    Entity,
    Index,
    OneToMany,
    ManyToOne,
    JoinColumn,
    PrimaryGeneratedColumn,
    UpdateDateColumn,
} from 'typeorm';
import { NumericTransformer } from './database/transformers/numeric.transformer';
import { User } from '../../users/entities/user.entity';
import { RentalOrderItem } from './rental-order-item.entity';

@Entity({ name: 'rental_orders' })
export class RentalOrder {
    @PrimaryGeneratedColumn({ type: 'integer', name: 'id_rental_order' })
    id_rental_order!: number;

    /** FK -> users.user_id */
    @Index()
    @Column({ name: 'user_id', type: 'integer' })
    userId!: number;

    @Column({
        name: 'total_price',
        type: 'numeric',
        precision: 12,
        scale: 2,
        default: 0,
        transformer: new NumericTransformer(),
    })
    totalPrice!: number;

    @Column({
        name: 'total_deposit',
        type: 'numeric',
        precision: 12,
        scale: 2,
        default: 0,
        transformer: new NumericTransformer(),
    })
    totalDeposit!: number;

    @Column({
        name: 'status',
        type: 'varchar',
        length: 50,
        default: 'pending',
    })
    status!: string;

    @Column({ name: 'note', type: 'text', nullable: true })
    note?: string | null;

    @CreateDateColumn({ name: 'created_at', type: 'timestamp without time zone' })
    createdAt!: Date;

    @UpdateDateColumn({ name: 'updated_at', type: 'timestamp without time zone' })
    updatedAt!: Date;

    // -------- RELATIONS --------

    /** rental_orders.user_id -> users.user_id */
    @ManyToOne(() => User, (user) => user.orders, {
        onDelete: 'RESTRICT',
        onUpdate: 'CASCADE',
    })
    @JoinColumn({ name: 'user_id', referencedColumnName: 'user_id' })
    user!: User;

    /** rental_orders.id_rental_order -> rental_order_items.rental_order_id */
    @OneToMany(() => RentalOrderItem, (item) => item.order)
    items!: RentalOrderItem[];
}
