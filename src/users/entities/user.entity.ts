import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  OneToMany,
  OneToOne,
  JoinColumn,
  ManyToOne,
  ManyToMany,
  JoinTable,
} from 'typeorm';
import { Order } from '../../orders/entities/order.entity';
import { Cart } from '../../cart/entities/cart.entity';
import { Address } from './address.entity';
import { UserProfileIndividual } from './user_profile_individual.entity';
import { UserProfileBusiness } from './user_profile_business.entity';
import { Role } from '../../role/entities/role.entity';
import { Permission } from '../../permission/entities/permission.entity';
import { UserPermission } from './user-permission.entity';

export enum CustomerType {
  INDIVIDUAL = 'individual',
  BUSINESS = 'business',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  user_id: number;

  /* ================= CORE FIELDS (BẮT BUỘC) ================= */

  @Column({ length: 50 })
  username: string;

  @Column({ unique: true, length: 100 })
  email: string;

  @Column({ length: 255 })
  password_hash: string;

  @ManyToOne(() => Role, { eager: true, nullable: false })
  @JoinColumn({ name: 'role_id' })
  role: Role;

  /* ================= OPTIONAL FIELDS ================= */

  @Column({ length: 255, nullable: true })
  images_url?: string;

  @Column({
    type: 'enum',
    enum: CustomerType,
    default: CustomerType.INDIVIDUAL,
  })
  customer_type: CustomerType;

  @Column({ length: 255, nullable: true })
  avatar_url?: string;

  @Column({
    name: 'email_verified',
    type: 'boolean',
    default: false,
  })
  emailVerified: boolean;

  @Column({
    name: 'verify_token',
    type: 'text',
    nullable: true,
  })
  verifyToken?: string;

  @CreateDateColumn()
  created_at: Date;

  /* ================= RELATIONS (KHÔNG BẮT BUỘC KHI TẠO) ================= */

  @OneToMany(() => Order, order => order.user)
  orders?: Order[];

  @OneToOne(() => Cart, cart => cart.user)
  cart?: Cart;

  @OneToMany(() => Address, address => address.user)
  addresses?: Address[];

  @OneToOne(() => UserProfileIndividual, profile => profile.user)
  profile_individual?: UserProfileIndividual;

  @OneToOne(() => UserProfileBusiness, profile => profile.user)
  profile_business?: UserProfileBusiness;

  @ManyToMany(() => Permission, { eager: true })
  @JoinTable({
    name: 'user_permissions',
    joinColumn: { name: 'user_id' },
    inverseJoinColumn: { name: 'permission_id' },
  })
  permissions: Permission[];

  @OneToMany(
    () => UserPermission,
    up => up.user,
    { eager: true },
  )
  permissionOverrides: UserPermission[];

}
