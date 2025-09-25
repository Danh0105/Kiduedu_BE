import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('addresses')
export class Address {
  @PrimaryGeneratedColumn()
  address_id: number;

  @ManyToOne(() => User, user => user.addresses, { onDelete: 'CASCADE' })
  user: User;

  @Column({ length: 100 })
  full_name: string;

  @Column({ length: 20 })
  phone_number: string;

  @Column({ length: 255 })
  street: string;

  @Column({ length: 100 })
  ward: string;

  @Column({ length: 100 })
  district: string;

  @Column({ length: 100 })
  city: string;

  @Column({ default: false })
  is_default: boolean;


}
