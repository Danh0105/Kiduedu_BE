import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CustomerServiceEntity } from './customer-service.entity';

@Injectable()
export class CustomerServiceService {
    constructor(
        @InjectRepository(CustomerServiceEntity)
        private readonly csRepo: Repository<CustomerServiceEntity>,
    ) { }

    findAll() {
        return this.csRepo.find();
    }

    async findOne(id: string) {
        const service = await this.csRepo.findOne({ where: { id } });
        if (!service) throw new NotFoundException(`Customer service with id ${id} not found`);
        return service;
    }

    async create(data: Partial<CustomerServiceEntity>) {
        const service = this.csRepo.create(data);
        return await this.csRepo.save(service);
    }

    async update(id: string, data: Partial<CustomerServiceEntity>) {
        const service = await this.findOne(id);
        Object.assign(service, data);
        return await this.csRepo.save(service);
    }

    async remove(id: string) {
        const service = await this.findOne(id);
        return await this.csRepo.remove(service);
    }
}
