import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToOne,
    JoinColumn,
} from 'typeorm';
import { InventoryReceipt } from './inventory-receipt.entity';
// import { ProductVariant } from '...'; // nếu sau này có entity cho variant

@Entity('inventory_receipt_items')
export class InventoryReceiptItem {
    @PrimaryGeneratedColumn({
        type: 'bigint',
        name: 'item_id',
    })
    itemId: number;

    @Column('bigint', {
        name: 'receipt_id',
    })
    receiptId: number;

    @Column('int', {
        name: 'variant_id',
        nullable: true,
    })
    variantId: number | null;

    @Column('int', {
        name: 'quantity',
    })
    quantity: number;

    @Column('numeric', {
        name: 'unit_cost',
        precision: 18,
        scale: 2,
    })
    unitCost: number;

    @Column('numeric', {
        name: 'line_total',
        precision: 18,
        scale: 2,
    })
    lineTotal: number;

    @Column('timestamptz', {
        name: 'created_at',
        default: () => 'CURRENT_TIMESTAMP',
    })
    createdAt: Date;

    // ------------ Relations (tuỳ chọn, nếu muốn dùng) ------------
    @ManyToOne(() => InventoryReceipt, (r) => r.items, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'receipt_id', referencedColumnName: 'receiptId' })
    receipt: InventoryReceipt;

    // Nếu có entity ProductVariant thì mở comment
    // @ManyToOne(() => ProductVariant, (v) => v.receiptItems)
    // @JoinColumn({ name: 'variant_id', referencedColumnName: 'variantId' })
    // variant: ProductVariant;
}
