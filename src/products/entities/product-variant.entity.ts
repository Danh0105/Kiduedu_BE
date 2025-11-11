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
    Index,
} from 'typeorm';
import { ProductVariantInventory } from './product-variant-inventory.entity';
import { ProductVariantPrice } from './product-variant-price.entity';
import { ProductVariantRentalPrice } from './product-variant-rental-price.entity';
import { ProductVariantRental } from './product-variant-rental.entity';
import { Product } from './product.entity';
import { OrderItem } from 'src/orders/entities/order-item.entity';

export type SpecItem = {
    key: string;
    label: string;
    value: string;
    unit?: string | null;
    type?: 'text' | 'number' | 'boolean';
    group?: string | null;
    note?: string | null;
    order?: number;
};

@Entity('product_variants')
export class ProductVariant {
    @PrimaryGeneratedColumn({ name: 'variant_id' })
    variantId: number;

    @Index()
    @Column({ name: 'product_id', type: 'int' })
    productId: number;

    @Column({ name: 'variant_name', length: 255 })
    variantName: string;

    @Index({ unique: false })
    @Column({ length: 50, nullable: true })
    sku?: string;

    @Index({ unique: false })
    @Column({ length: 64, nullable: true })
    barcode?: string;

    @Column({ default: 1 })
    status: number;

    /** 🔧 Thuộc tính/metadata linh hoạt ở cấp biến thể (JSONB) */
    @Column({
        name: 'attributes',
        type: 'jsonb',
        nullable: false,
        default: () => `'{}'::jsonb`,
    })
    attributes: Record<string, any>;

    /** (tuỳ chọn) Kích thước/khối lượng nếu bạn muốn chuẩn hoá vài thuộc tính hay dùng */
    @Column({ name: 'weight_gram', type: 'int', nullable: true })
    weightGram?: number | null;

    @Column({ name: 'length_mm', type: 'int', nullable: true })
    lengthMm?: number | null;

    @Column({ name: 'width_mm', type: 'int', nullable: true })
    widthMm?: number | null;

    @Column({ name: 'height_mm', type: 'int', nullable: true })
    heightMm?: number | null;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at' })
    updatedAt: Date;

    // 1-1 Inventory
    @OneToOne(() => ProductVariantInventory, (inventory) => inventory.variant, { cascade: true })
    inventory: ProductVariantInventory;

    // 1-n Prices
    @OneToMany(() => ProductVariantPrice, (price) => price.variant, { cascade: true })
    prices: ProductVariantPrice[];

    // 1-n Rental Prices
    @OneToMany(() => ProductVariantRentalPrice, (rp) => rp.variant, { cascade: true })
    rentalPrices: ProductVariantRentalPrice[];

    // 1-n Rentals
    @OneToMany(() => ProductVariantRental, (r) => r.variant, { cascade: true })
    rentals: ProductVariantRental[];

    // n-1 Product
    @ManyToOne(() => Product, (product) => product.variants, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'product_id' })
    product: Product;

    @Column({ name: 'image_url', type: 'text', nullable: true })
    imageUrl?: string | null;

    @OneToMany(() => OrderItem, (item) => item.variant)
    orderItems: OrderItem[];

    /** 🧾 Thông số kỹ thuật (JSONB - mảng SpecItem) */
    @Column({ name: 'specs', type: 'jsonb', nullable: false, default: () => `'[]'::jsonb` })
    specs: SpecItem[];
}
