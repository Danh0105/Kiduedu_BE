import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Supplier } from '../entities/supplier.entity';

@Injectable()
export class SupplierService {
    constructor(
        @InjectRepository(Supplier)
        private repo: Repository<Supplier>,
    ) { }

    /* =================== CREATE =================== */
    async create(data: Partial<Supplier>) {
        const supplier = this.repo.create(data);
        return this.repo.save(supplier);
    }

    /* =================== GET ALL =================== */
    async findAll() {
        return this.repo.find({
            order: { supplierId: 'DESC' },
        });
    }

    /* =================== GET ONE =================== */
    async findOne(id: number) {
        const supplier = await this.repo.findOne({
            where: { supplierId: id },
        });

        if (!supplier) {
            throw new NotFoundException('Nhà cung cấp không tồn tại');
        }

        return supplier;
    }

    /* =================== UPDATE =================== */
    async update(id: number, data: Partial<Supplier>) {
        const supplier = await this.findOne(id);

        Object.assign(supplier, data);

        return this.repo.save(supplier);
    }

    /* =================== DELETE =================== */
    async remove(id: number) {
        const supplier = await this.findOne(id);
        await this.repo.remove(supplier);
        return { message: 'Xoá nhà cung cấp thành công' };
    }
}
