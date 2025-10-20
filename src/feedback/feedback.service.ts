import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Feedback } from './feedback.entity';

@Injectable()
export class FeedbackService {
    constructor(
        @InjectRepository(Feedback)
        private readonly feedbackRepo: Repository<Feedback>,
    ) { }

    findAll() {
        return this.feedbackRepo.find({
            order: { createdAt: 'DESC' },
        });
    }

    async create(data: Partial<Feedback>) {
        const feedback = this.feedbackRepo.create(data);
        return await this.feedbackRepo.save(feedback);
    }
}
