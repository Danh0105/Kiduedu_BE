import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Participant } from './participant.entity';

@Injectable()
export class ParticipantsService {
    constructor(
        @InjectRepository(Participant)
        private readonly repo: Repository<Participant>,
    ) { }

    // FE gửi danh sách người tham gia
    async import(list: { fullName: string; birthDate: string }[]) {
        if (!Array.isArray(list) || list.length === 0) {
            throw new BadRequestException('Danh sách không hợp lệ');
        }

        const entities = list.map(item =>
            this.repo.create({
                fullName: item.fullName.trim(),
                birthDate: item.birthDate,
            }),
        );

        await this.repo.save(entities);
        return this.getRemaining();
    }

    // Danh sách còn trong vòng quay
    async getRemaining() {
        return this.repo.find({
            where: { isWinner: false },
            order: { id: 'ASC' },
        });
    }

    // RANDOM NGƯỜI TRÚNG
    async spin() {
        return this.repo.manager.transaction(async manager => {
            const participants = await manager.find(Participant, {
                where: { isWinner: false },
                lock: { mode: 'pessimistic_write' },
            });

            if (participants.length === 0) {
                throw new BadRequestException('Không còn người để quay');
            }

            const winner =
                participants[Math.floor(Math.random() * participants.length)];

            winner.isWinner = true;
            await manager.save(winner);

            const remaining = await manager.find(Participant, {
                where: { isWinner: false },
            });

            return { winner, remaining };
        });
    }


    // Reset (admin)
    async reset() {
        await this.repo.update({}, { isWinner: false });
        return this.getRemaining();
    }
}
