import {
    Column,
    Entity,
    PrimaryGeneratedColumn,
    CreateDateColumn,
} from 'typeorm';

@Entity('prizes')
export class Prize {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({ length: 100 })
    name: string;

    @Column({ type: 'int' })
    quantity: number;

    // Tỷ lệ trúng (VD: 0.1 = 10%)
    @Column({ type: 'float' })
    probability: number;

    @CreateDateColumn()
    createdAt: Date;
}
