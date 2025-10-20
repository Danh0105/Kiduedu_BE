import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Policy } from './policy.entity';

@Injectable()
export class PolicyService {
    constructor(
        @InjectRepository(Policy)
        private policyRepository: Repository<Policy>,
    ) { }

    findAll() {
        return this.policyRepository.find();
    }

    async findOne(id: string) {
        const policy = await this.policyRepository.findOne({ where: { id } });
        if (!policy) throw new NotFoundException('Policy not found');
        return policy;
    }

    create(data: Partial<Policy>) {
        const policy = this.policyRepository.create(data);
        return this.policyRepository.save(policy);
    }

    async update(id: string, data: Partial<Policy>) {
        await this.policyRepository.update(id, data);
        return this.findOne(id);
    }

    async remove(id: string) {
        const policy = await this.findOne(id);
        return this.policyRepository.remove(policy);
    }
}
