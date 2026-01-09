import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { ProductVariantOptionValue } from '../entities/product-variant-option-value.entity';
import { OptionValue } from '../entities/option-value.entity';
import { AddVariantOptionDto } from '../dto/add-variant-option.dto';
import { ProductVariant } from '../entities/product-variant.entity';

@Injectable()
export class ProductVariantOptionsService {
    constructor(
        @InjectRepository(ProductVariantOptionValue)
        private readonly variantOptionRepo: Repository<ProductVariantOptionValue>,

        @InjectRepository(OptionValue)
        private readonly optionValueRepo: Repository<OptionValue>,

        @InjectRepository(ProductVariant)
        private readonly variantsRepo: Repository<ProductVariant>,
    ) { }

    async listOptions(productId: number) {
        const list = await this.variantOptionRepo.find({
            where: { productId },
            relations: ['optionValue'],
        });

        return list.map((v) => ({
            option_value_id: v.optionValue.optionValueId,
            option_value: v.optionValue.value,
        }));
    }

    async addOption(productId: number, dto: AddVariantOptionDto) {
        const option = await this.optionValueRepo.findOne({
            where: { optionValueId: dto.optionValueId },
        });

        if (!option) throw new NotFoundException('Option value không tồn tại');

        const exist = await this.variantOptionRepo.findOne({
            where: {
                productId,
                optionValueId: dto.optionValueId,
            },
        });

        if (exist)
            throw new ConflictException('Option value này đã tồn tại trong variant');

        const newLink = this.variantOptionRepo.create({
            productId,
            optionValueId: dto.optionValueId,
        });

        return this.variantOptionRepo.save(newLink);
    }

    async removeOption(productId: number, optionValueId: number) {
        const record = await this.variantOptionRepo.findOne({
            where: { productId, optionValueId },
        });

        if (!record)
            throw new NotFoundException('Option value không thuộc variant này');

        await this.variantOptionRepo.delete({ productId, optionValueId });

        return { message: 'Đã xóa option value khỏi variant' };
    }

}
