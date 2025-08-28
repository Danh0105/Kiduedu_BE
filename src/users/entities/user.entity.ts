import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, OneToMany, OneToOne } from 'typeorm';
import { Order } from '../../orders/entities/order.entity';
import { Cart } from '../../cart/entities/cart.entity';
@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  user_id: number;

  @Column({ unique: true, length: 50 })
  username: string;

  @Column({ unique: true, length: 100 })
  email: string;

  @Column({ length: 255 })
  password_hash: string;

  @Column({ length: 100, nullable: true })
  full_name: string;

  @Column({ length: 20, nullable: true })
  phone_number: string;

  @Column({ default: 'customer' })
  role: string;

  @CreateDateColumn()
  created_at: Date;

  @OneToMany(() => Order, order => order.user)
  orders: Order[];

  @OneToOne(() => Cart, cart => cart.user)
  cart: Cart;
}
