import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductVariantOptionValue } from '../entities/product-variant-option-value.entity';
import { OptionValue } from '../entities/option-value.entity';
import { AddVariantOptionDto } from '../dto/add-variant-option.dto';

@Injectable()
export class ProductVariantOptionsService {
    constructor(
        @InjectRepository(ProductVariantOptionValue)
        private readonly variantOptionRepo: Repository<ProductVariantOptionValue>,

        @InjectRepository(OptionValue)
        private readonly optionValueRepo: Repository<OptionValue>,
    ) { }

    async listOptions(variantId: number) {
        const list = await this.variantOptionRepo.find({
            where: { variantId },
            relations: ['optionValue'],
        });

        return list.map((v) => ({
            option_value_id: v.optionValue.optionValueId,
            option_value: v.optionValue.value,
        }));
    }

    async addOption(variantId: number, dto: AddVariantOptionDto) {
        const option = await this.optionValueRepo.findOne({
            where: { optionValueId: dto.optionValueId },
        });

        if (!option) throw new NotFoundException('Option value không tồn tại');

        const exist = await this.variantOptionRepo.findOne({
            where: {
                variantId,
                optionValueId: dto.optionValueId,
            },
        });

        if (exist)
            throw new ConflictException('Option value này đã tồn tại trong variant');

        const newLink = this.variantOptionRepo.create({
            variantId,
            optionValueId: dto.optionValueId,
        });

        return this.variantOptionRepo.save(newLink);
    }

    async removeOption(variantId: number, optionValueId: number) {
        const record = await this.variantOptionRepo.findOne({
            where: { variantId, optionValueId },
        });

        if (!record)
            throw new NotFoundException('Option value không thuộc variant này');

        await this.variantOptionRepo.delete({ variantId, optionValueId });

        return { message: 'Đã xóa option value khỏi variant' };
    }
}
