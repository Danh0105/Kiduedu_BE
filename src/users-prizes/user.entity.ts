import {
    Entity,
    Column,
    PrimaryGeneratedColumn,
    CreateDateColumn,
} from 'typeorm';

@Entity('users')
export class User {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({ length: 100 })
    name: string;

    @Column({ length: 100, nullable: true })
    email: string;

    @Column({ length: 100, nullable: true })
    department: string;

    @Column({ default: false })
    hasSpun: boolean;

    @CreateDateColumn()
    createdAt: Date;
}
