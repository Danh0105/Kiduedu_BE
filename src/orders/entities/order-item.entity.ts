import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Order } from './order.entity';
import { ProductVariant } from '../../products/entities/product-variant.entity';

@Entity('order_items')
export class OrderItem {
  @PrimaryGeneratedColumn({ name: 'order_item_id' })
  orderItemId: number;

  @Index()
  @Column({ name: 'order_id', type: 'int' })
  orderId: number;

  @ManyToOne(() => Order, (order) => order.items, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'order_id' })
  order: Order;


  @Column({ name: 'variant_id', type: 'int', nullable: true })
  variantId: number | null;



  @ManyToOne(() => ProductVariant, (variant) => variant.orderItems, {
    nullable: true,
    onDelete: 'RESTRICT',   // không cho xóa variant khi đã có order
    onUpdate: 'CASCADE',
  })
  @JoinColumn({ name: 'variant_id', referencedColumnName: 'variantId' })
  variant: ProductVariant | null;




  @Column({ type: 'int', default: 1 })
  quantity: number;

  @Column({
    name: 'price_per_unit',
    type: 'numeric',
    nullable: false,
    transformer: {
      to: (v: number) => v,
      from: (v: string) => Number(v),
    },
  })
  pricePerUnit: number;

  @Column({
    name: 'attributes',
    type: 'jsonb',
    nullable: false,
    default: () => `'{}'::jsonb`,
  })
  attributes: Record<string, any>;
}
