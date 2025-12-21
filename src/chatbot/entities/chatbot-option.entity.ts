import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToOne,
    JoinColumn,
    Index,
    CreateDateColumn,
} from 'typeorm';
import { ChatbotNode } from './chatbot-node.entity';

@Entity('chatbot_options')
export class ChatbotOption {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({ name: 'node_id' })
    nodeId: number;

    @ManyToOne(() => ChatbotNode, node => node.options, {
        onDelete: 'CASCADE',
    })
    @JoinColumn({ name: 'node_id' })
    node: ChatbotNode;

    @Column({ length: 255 })
    label: string;

    @Column({ length: 50, nullable: true })
    icon?: string;

    @Column({ name: 'next_node_key', length: 100 })
    nextNodeKey: string;

    @Column({ name: 'sort_order', default: 0 })
    sortOrder: number;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;
}

