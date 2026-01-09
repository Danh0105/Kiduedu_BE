import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToMany,
    JoinTable,
    Index,
} from 'typeorm';
import { Permission } from '../../permission/entities/permission.entity';

@Entity('roles')
export class Role {
    @PrimaryGeneratedColumn()
    id: number;

    @Index()
    @Column({ unique: true })
    name: string;

    @Column({ nullable: true })
    description?: string;

    @ManyToMany(() => Permission, { eager: true })
    @JoinTable({
        name: 'role_permissions',
        joinColumn: { name: 'role_id' },
        inverseJoinColumn: { name: 'permission_id' },
    })
    permissions: Permission[];
}
