import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ChatbotNode } from './entities/chatbot-node.entity';
import { ChatbotOption } from './entities/chatbot-option.entity';
import { CreateNodeDto } from './dto/create-node.dto';
import { UpdateNodeDto } from './dto/update-node.dto';
import { CreateOptionDto } from './dto/create-option.dto';
import { UpdateOptionDto } from './dto/update-option.dto';

@Injectable()
export class ChatbotService {
    constructor(
        @InjectRepository(ChatbotNode)
        private readonly nodeRepo: Repository<ChatbotNode>,

        @InjectRepository(ChatbotOption)
        private readonly optionRepo: Repository<ChatbotOption>,
    ) { }

    /* ================= NODE ================= */

    async findAllNodes() {
        return this.nodeRepo.find({
            relations: ['options'],
            order: {
                id: 'ASC',
                options: { sortOrder: 'ASC' },
            },
        });
    }

    async findNodeByKey(key: string) {
        const node = await this.nodeRepo.findOne({
            where: { key },
            relations: ['options'],
            order: { options: { sortOrder: 'ASC' } },
        });

        if (!node) throw new NotFoundException('Node not found');
        return node;
    }

    async createNode(dto: CreateNodeDto) {
        if (dto.isStart) {
            await this.nodeRepo.update({ isStart: true }, { isStart: false });
        }

        const node = this.nodeRepo.create(dto);
        return this.nodeRepo.save(node);
    }

    async updateNode(id: number, dto: UpdateNodeDto) {
        const node = await this.nodeRepo.findOneBy({ id });
        if (!node) throw new NotFoundException('Node not found');

        if (dto.isStart) {
            await this.nodeRepo.update({ isStart: true }, { isStart: false });
        }

        Object.assign(node, dto);
        return this.nodeRepo.save(node);
    }

    async deleteNode(id: number) {
        const node = await this.nodeRepo.findOneBy({ id });
        if (!node) throw new NotFoundException('Node not found');

        return this.nodeRepo.remove(node);
    }

    /* ================= OPTION ================= */

    async createOption(dto: CreateOptionDto) {
        const option = this.optionRepo.create({
            ...dto,
            nextNodeKey: dto.nextNodeKey ?? '',
        });
        return this.optionRepo.save(option);
    }


    async updateOption(id: number, dto: UpdateOptionDto) {
        const option = await this.optionRepo.findOneBy({ id });
        if (!option) throw new NotFoundException('Option not found');

        Object.assign(option, dto);
        return this.optionRepo.save(option);
    }

    async deleteOption(id: number) {
        const option = await this.optionRepo.findOneBy({ id });
        if (!option) throw new NotFoundException('Option not found');

        return this.optionRepo.remove(option);
    }
    async findStartNode() {
        const node = await this.nodeRepo.findOne({
            where: { isStart: true },
            relations: ['options'],
            order: { options: { sortOrder: 'ASC' } },
        });

        if (!node) {
            throw new Error('No start node found');
        }
        return node;
    }

}
