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

    @Column({ length: 150, unique: true, nullable: true })
    email: string;

    @Column({ name: 'qr_code', length: 255, unique: true, nullable: true })
    qrCode: string;

    @Column({ name: 'is_checked_in', default: false })
    isCheckedIn: boolean;

    @Column({ name: 'checked_in_at', type: 'timestamp', nullable: true })
    checkedInAt: Date;

    @Column({ name: 'is_winner', default: false })
    isWinner: boolean;

    @Column({ name: 'is_forced_winner', default: false })
    isForcedWinner: boolean;

    @Column({ length: 200, nullable: true })
    position: string;

    @Column({
        name: 'guest_type',
        nullable: true
    })
    guestType: string;

    @Column({ nullable: true })
    avatar: string;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @Column({ length: 100, nullable: true })
    department: string;
}
