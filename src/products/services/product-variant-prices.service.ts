import {
    Injectable,
    NotFoundException,
    BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductVariantPrice } from '../entities/product-variant-price.entity';
import { CreateVariantPriceDto } from '../dto/create-variant-price.dto';
import { UpdateVariantPriceDto } from '../dto/update-variant-price.dto';

@Injectable()
export class ProductVariantPricesService {
    constructor(
        @InjectRepository(ProductVariantPrice)
        private readonly priceRepo: Repository<ProductVariantPrice>,
    ) { }

    /**
     * 📄 Lấy tất cả giá của một variant
     */
    async findAll(variantId: number) {
        return this.priceRepo.find({
            where: { variantId: variantId },
            order: { startAt: 'DESC' },
        });
    }

    /**
     * 🔍 Lấy chi tiết một giá theo ID
     */
    async findOne(variantId: number, priceId: number) {
        const price = await this.priceRepo.findOne({
            where: { variantId: variantId, priceId: priceId },
        });

        if (!price) {
            throw new NotFoundException('Không tìm thấy giá cho biến thể này');
        }

        return price;
    }

    /**
     * ➕ Tạo mới giá
     */
    async create(variantId: number, dto: CreateVariantPriceDto) {
        if (dto.price <= 0) {
            throw new BadRequestException('Giá phải lớn hơn 0');
        }

        const price = this.priceRepo.create({
            variantId: variantId,
            priceType: dto.priceType,
            currencyCode: dto.currencyCode,
            price: dto.price,
            startAt: dto.startAt,
            endAt: dto.endAt,
        });



        return this.priceRepo.save(price);
    }

    /**
     * 📝 Cập nhật giá
     */
    async update(variantId: number, priceId: number, dto: UpdateVariantPriceDto) {
        const record = await this.findOne(variantId, priceId);

        const updated = Object.assign(record, dto);

        return this.priceRepo.save(updated);
    }

    /**
     * ❌ Xóa giá
     */
    async remove(variantId: number, priceId: number) {
        const record = await this.findOne(variantId, priceId);
        await this.priceRepo.remove(record);

        return { message: 'Đã xóa giá của biến thể' };
    }
}
