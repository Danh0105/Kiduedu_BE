import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Prize } from './prize.entity';

@Injectable()
export class PrizesService {
    constructor(
        @InjectRepository(Prize)
        private readonly prizeRepo: Repository<Prize>,
    ) { }

    create(data: Partial<Prize>) {
        const prize = this.prizeRepo.create(data);
        return this.prizeRepo.save(prize);
    }

    findAll() {
        return this.prizeRepo.find({
            order: { createdAt: 'DESC' },
        });
    }

    findOne(id: number) {
        return this.prizeRepo.findOneBy({ id });
    }

    async update(id: number, data: Partial<Prize>) {
        const prize = await this.findOne(id);
        if (!prize) throw new NotFoundException('Prize not found');

        Object.assign(prize, data);
        return this.prizeRepo.save(prize);
    }

    async remove(id: number) {
        const prize = await this.findOne(id);
        if (!prize) throw new NotFoundException('Prize not found');

        return this.prizeRepo.remove(prize);
    }
}
