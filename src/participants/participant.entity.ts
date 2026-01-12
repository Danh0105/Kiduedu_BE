import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
} from 'typeorm';

@Entity('participants')
export class Participant {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({ name: 'full_name', length: 100 })
    fullName: string;

    @Column({ name: 'birth_date', type: 'date' })
    birthDate: string;

    @Column({ name: 'is_winner', default: false })
    isWinner: boolean;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;
}

