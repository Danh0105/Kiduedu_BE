import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    OneToMany,
    ManyToOne,
    JoinColumn,
} from 'typeorm';
import { InventoryReceipt } from './inventory-receipt.entity';

@Entity('suppliers')
export class Supplier {
    @PrimaryGeneratedColumn({
        type: 'int',
        name: 'supplier_id',
    })
    supplierId: number;

    @Column('varchar', {
        name: 'supplier_name',
        length: 255,
    })
    supplierName: string;

    @Column('varchar', {
        name: 'phone',
        length: 20,
        nullable: true,
    })
    phone?: string | null;

    @Column('varchar', {
        name: 'email',
        length: 255,
        nullable: true,
    })
    email?: string | null;

    @Column('text', {
        name: 'address',
        nullable: true,
    })
    address?: string | null;

    @Column('text', {
        name: 'note',
        nullable: true,
    })
    note?: string | null;

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

    // Quan hệ với phiếu nhập (nếu dùng)
    @OneToMany(() => InventoryReceipt, (r) => r.supplier)
    receipts: InventoryReceipt[];
}
