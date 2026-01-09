// src/users/entities/user-permission.entity.ts
import {
    Entity,
    Column,
    ManyToOne,
    JoinColumn,
    PrimaryColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Permission } from '../../permission/entities/permission.entity';

@Entity('user_permissions')
export class UserPermission {

    @PrimaryColumn({ name: 'user_id' })
    userId: number;

    @PrimaryColumn({ name: 'permission_id' })
    permissionId: number;

    @ManyToOne(() => User, user => user.permissionOverrides, {
        onDelete: 'CASCADE',
    })
    @JoinColumn({ name: 'user_id' })
    user: User;

    @ManyToOne(() => Permission, {
        eager: true,
        onDelete: 'CASCADE',
    })
    @JoinColumn({ name: 'permission_id' })
    permission: Permission;

    @Column({ default: true })
    granted: boolean;
}
