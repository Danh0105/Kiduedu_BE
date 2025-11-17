// address.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';

@Entity('addresses')
export class Address {
  @PrimaryGeneratedColumn({ name: 'address_id' })
  addressId: number;

  @Column({ name: 'full_name', length: 100 })
  full_name: string;

  @Column({ name: 'phone_number', length: 20 })
  phone_number: string;

  @Column({ name: 'street', length: 255 })
  street: string;

  @Column({ name: 'ward', length: 100 })
  ward: string;

  @Column({ name: 'district', length: 100 })
  district: string;

  @Column({ name: 'city', length: 100 })
  city: string;

  @Column({ name: 'is_default', type: 'boolean', default: false })
  is_default: boolean;

  // cột userUserId trong DB
  @ManyToOne(() => User, (u) => u.addresses)
  @JoinColumn({ name: 'userUserId' })
  user: User;
}
