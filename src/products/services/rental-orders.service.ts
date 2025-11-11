// src/modules/rental-orders/rental-orders.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, FindOptionsWhere } from 'typeorm';
import { RentalOrder } from '../entities/rental-order.entity';
import { CreateRentalOrderDto } from '../dto/create-rental-order.dto';
import { UpdateRentalOrderDto } from '../dto/update-rental-order.dto';

interface FindAllOpts {
    page: number;
    limit: number;
    userId?: number;
    status?: string;
    withItems?: boolean;
    withUser?: boolean;
    createdFrom?: string;
    createdTo?: string;
}

@Injectable()
export class RentalOrdersService {
    constructor(
        @InjectRepository(RentalOrder)
        private readonly repo: Repository<RentalOrder>,
    ) { }

    async create(dto: CreateRentalOrderDto) {
        const entity = this.repo.create({
            userId: dto.userId,
            totalPrice: dto.totalPrice,
            totalDeposit: dto.totalDeposit,
            status: dto.status ?? 'pending',
            note: dto.note,
        });
        return this.repo.save(entity);
    }

    async findAll(opts: FindAllOpts) {
        const { page, limit, userId, status, withItems, withUser, createdFrom, createdTo } = opts;

        const where: FindOptionsWhere<RentalOrder> = {};
        if (userId) where.userId = userId;
        if (status) where.status = status as any;
        if (createdFrom || createdTo) {
            const from = createdFrom ? new Date(createdFrom) : new Date('1970-01-01');
            const to = createdTo ? new Date(createdTo + 'T23:59:59') : new Date();
            (where as any).createdAt = Between(from, to);
        }

        const [data, total] = await this.repo.findAndCount({
            where,
            order: { id_rental_order: 'DESC' },
            relations: {
                items: !!withItems,
                user: !!withUser,
            },
            skip: (page - 1) * limit,
            take: limit,
        });

        return {
            data,
            pagination: {
                page,
                limit,
                total,
                totalPages: Math.ceil(total / limit),
            },
        };
    }

    async findOne(id: number, opts?: { withItems?: boolean; withUser?: boolean }) {
        const entity = await this.repo.findOne({
            where: { id_rental_order: id },
            relations: {
                items: !!opts?.withItems,
                user: !!opts?.withUser,
            },
        });
        if (!entity) throw new NotFoundException('Rental order not found');
        return entity;
    }

    async update(id: number, dto: UpdateRentalOrderDto) {
        const pre = await this.findOne(id);
        Object.assign(pre, dto);
        return this.repo.save(pre);
    }

    async remove(id: number) {
        const pre = await this.findOne(id);
        await this.repo.remove(pre);
        return { success: true };
    }

    // convenience method cho /:id/items
    async listItems(id: number) {
        const order = await this.repo.findOne({
            where: { id_rental_order: id },
            relations: { items: true },
        });
        if (!order) throw new NotFoundException('Rental order not found');
        return order.items ?? [];
    }
}
