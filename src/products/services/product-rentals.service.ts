// src/modules/products/services/product-rentals.service.ts
import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductVariantRentalPrice } from '../entities/product-variant-rental-price.entity';
import { ProductVariantRental } from '../entities/product-variant-rental.entity';
import { CreateRentalDto } from '../dto/create-rental.dto';

@Injectable()
export class ProductRentalsService {
    constructor(
        @InjectRepository(ProductVariantRentalPrice)
        private readonly rentalPriceRepo: Repository<ProductVariantRentalPrice>,

        @InjectRepository(ProductVariantRental)
        private readonly rentalRepo: Repository<ProductVariantRental>,
    ) { }

    /**
     * Lấy bảng giá thuê theo variantId
     */
    async getRentalPrices(variantId: number) {
        return this.rentalPriceRepo.find({
            where: { variantId },
            order: { rentalType: 'ASC' },
        });
    }

    /**
     * Tạo mới lượt thuê
     */
    async createRental(userId: number, dto: CreateRentalDto) {
        const priceInfo = await this.rentalPriceRepo.findOne({
            where: { variantId: dto.variantId, rentalType: dto.rentalType },
        });

        if (!priceInfo) {
            throw new NotFoundException('Không tìm thấy bảng giá cho loại thuê này');
        }

        const start = new Date(dto.startDate);
        const end = new Date(dto.endDate);
        const days = Math.ceil((end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24));
        if (days <= 0) throw new BadRequestException('Khoảng thời gian thuê không hợp lệ');

        let totalPrice = priceInfo.price;
        if (dto.rentalType === 'daily') totalPrice = priceInfo.price * days;
        if (dto.rentalType === 'weekly') totalPrice = priceInfo.price * Math.ceil(days / 7);
        if (dto.rentalType === 'monthly') totalPrice = priceInfo.price * Math.ceil(days / 30);

        const rental = this.rentalRepo.create({
            variantId: dto.variantId,
            userId,
            rentalType: dto.rentalType,
            startDate: dto.startDate,
            endDate: dto.endDate,
            totalPrice,
            depositPaid: dto.depositPaid,
            status: 'pending',
        });

        return this.rentalRepo.save(rental);
    }

    /**
     * Lấy danh sách lượt thuê theo variant
     */
    async listRentals(variantId: number) {
        return this.rentalRepo.find({
            where: { variantId },
            order: { createdAt: 'DESC' },
        });
    }
}
