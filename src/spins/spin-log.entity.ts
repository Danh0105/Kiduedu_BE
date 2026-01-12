import {
    Entity,
    PrimaryGeneratedColumn,
    ManyToOne,
    CreateDateColumn,
    JoinColumn,
} from 'typeorm';
import { User } from '../users-prizes/user.entity';
import { Prize } from '../prizes/prize.entity';

@Entity('spin_logs')
export class SpinLog {
    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(() => User, { eager: true })
    @JoinColumn({ name: 'user_id' })
    user: User;

    @ManyToOne(() => Prize, { eager: true })
    @JoinColumn({ name: 'prize_id' })
    prize: Prize;

    @CreateDateColumn()
    createdAt: Date;
}
