import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { ProductVariant } from '../entities/product-variant.entity';
import { CreateProductVariantDto } from '../dto/create-product-variant.dto';
import { UpdateProductVariantDto } from '../dto/update-product-variant.dto';
import { ListVariantsQuery } from '../dto/list-variants.query';

@Injectable()
export class ProductVariantsService {
    constructor(
        @InjectRepository(ProductVariant)
        private readonly variantsRepo: Repository<ProductVariant>,
    ) { }

    private baseQB(productId: number): SelectQueryBuilder<ProductVariant> {
        return this.variantsRepo
            .createQueryBuilder('v')
            .where('v.productId = :productId', { productId });
    }

    async list(productId: number, q: ListVariantsQuery) {
        const page = Number(q.page ?? 1);
        const limit = Number(q.limit ?? 20);
        const offset = (page - 1) * limit;

        let qb = this.baseQB(productId);

        if (q.status !== undefined) qb = qb.andWhere('v.status = :status', { status: q.status });
        if (q.search) {
            qb = qb.andWhere(
                '(v.variantName ILIKE :kw OR v.sku ILIKE :kw)',
                { kw: `%${q.search}%` },
            );
        }

        // withPrice === 'true' → join subquery lấy current price (ưu tiên sale)
        if (q.withPrice === 'true') {
            qb = qb
                .leftJoin(
                    (subQ) =>
                        subQ
                            .select('p.variant_id', 'variant_id')
                            .addSelect(`
                COALESCE(
                  (
                    SELECT price FROM public.product_variant_prices sp
                    WHERE sp.variant_id = p.variant_id AND sp.price_type = 'sale'
                      AND sp.start_at <= now() AND (sp.end_at IS NULL OR sp.end_at > now())
                    ORDER BY sp.start_at DESC
                    LIMIT 1
                  ),
                  (
                    SELECT price FROM public.product_variant_prices rp
                    WHERE rp.variant_id = p.variant_id AND rp.price_type = 'retail'
                      AND rp.start_at <= now() AND (rp.end_at IS NULL OR rp.end_at > now())
                    ORDER BY rp.start_at DESC
                    LIMIT 1
                  )
                )
              `, 'current_price')
                            .from('public.product_variant_prices', 'p')
                            .groupBy('p.variant_id'),
                    'cp',
                    'cp.variant_id = v.variantId',
                )
                .addSelect('cp.current_price', 'current_price');
        }

        const [items, total] = await qb
            .orderBy('v.variantId', 'ASC')
            .offset(offset)
            .limit(limit)
            .getManyAndCount();

        return {
            page, limit, total, items,
            // nếu cần trả cả current_price khi withPrice='true', bạn có thể thay getRawAndEntities
        };
    }

    async findOne(productId: number, variantId: number) {
        const variant = await this.variantsRepo.findOne({
            where: { productId, variantId },
        });
        if (!variant) throw new NotFoundException('Variant not found');
        return variant;
    }

    async create(productId: number, dto: CreateProductVariantDto) {
        const entity = this.variantsRepo.create({
            ...dto,
            productId,
            attributes: dto.attributes ?? {},
            status: dto.status ?? 1,
        });
        return this.variantsRepo.save(entity);
    }

    async update(productId: number, variantId: number, dto: UpdateProductVariantDto) {
        const found = await this.findOne(productId, variantId);
        const merged = this.variantsRepo.merge(found, dto);
        return this.variantsRepo.save(merged);
    }

    async remove(productId: number, variantId: number) {
        const found = await this.findOne(productId, variantId);
        await this.variantsRepo.delete(found.variantId);
        return { success: true };
    }

    // (tuỳ chọn) Deactivate thay vì xóa cứng:
    async deactivate(productId: number, variantId: number) {
        const found = await this.findOne(productId, variantId);
        found.status = 0;
        return this.variantsRepo.save(found);
    }
}
