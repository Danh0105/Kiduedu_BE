import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    OneToMany,
    ManyToOne,
    JoinColumn,
} from 'typeorm';
import { InventoryReceiptItem } from './inventory-receipt-item.entity';
import { Supplier } from './supplier.entity';

@Entity('inventory_receipts')
export class InventoryReceipt {
    @PrimaryGeneratedColumn({
        type: 'bigint',
        name: 'receipt_id',
    })
    receiptId: number;

    @Column('varchar', {
        name: 'receipt_code',
        length: 50,
    })
    receiptCode: string;

    @Column('date', {
        name: 'receipt_date',
    })
    receiptDate: string; // hoặc Date

    @Column('int', {
        name: 'supplier_id',
    })
    supplierId: number; // sau này có thể @ManyToOne Supplier

    @Column('varchar', {
        name: 'reference_no',
        length: 100,
        nullable: true,
    })
    referenceNo?: string | null;

    @Column('text', {
        name: 'note',
        nullable: true,
    })
    note?: string | null;

    @Column('numeric', {
        name: 'total_amount',
        precision: 18,
        scale: 2,
        default: 0,
    })
    totalAmount: number;

    @Column('timestamptz', {
        name: 'created_at',
        default: () => 'CURRENT_TIMESTAMP',
    })
    createdAt: Date;

    @Column('timestamptz', {
        name: 'updated_at',
        default: () => 'CURRENT_TIMESTAMP',
        onUpdate: 'CURRENT_TIMESTAMP',
    })
    updatedAt: Date;

    // trong InventoryReceipt
    @OneToMany(() => InventoryReceiptItem, (item) => item.receipt)
    items: InventoryReceiptItem[];

    // trong InventoryReceipt entity
    @ManyToOne(() => Supplier, (s) => s.receipts)
    @JoinColumn({ name: 'supplier_id', referencedColumnName: 'supplierId' })
    supplier: Supplier;

}
