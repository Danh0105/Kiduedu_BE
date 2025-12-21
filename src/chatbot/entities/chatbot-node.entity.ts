import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    OneToMany,
    Index,
    CreateDateColumn,
    UpdateDateColumn,
} from 'typeorm';
import { ChatbotOption } from './chatbot-option.entity';

@Entity('chatbot_nodes')
export class ChatbotNode {
    @PrimaryGeneratedColumn()
    id: number;

    @Index({ unique: true })
    @Column({ length: 100 })
    key: string;

    @Column({ type: 'text' })
    content: string;

    @Column({ name: 'is_start', default: false })
    isStart: boolean;

    @OneToMany(() => ChatbotOption, option => option.node, {
        cascade: true,
    })
    options: ChatbotOption[];

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at' })
    updatedAt: Date;

}
