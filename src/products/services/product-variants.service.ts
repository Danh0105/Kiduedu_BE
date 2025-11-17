import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { ProductVariant } from '../entities/product-variant.entity';
import { CreateProductVariantDto } from '../dto/create-product-variant.dto';
import { UpdateProductVariantDto } from '../dto/update-product-variant.dto';
import { ListVariantsQuery } from '../dto/list-variants.query';

const PRICE_TYPES = {
    PRIORITY: 'promo', // giá được ưu tiên nếu cùng thời điểm (vd: khuyến mãi)
    FALLBACK: 'base',  // giá nền nếu không có promo
};

/** Kiểu SpecItem dùng để chuẩn hoá dữ liệu trả về cho FE */
type SpecItem = {
    key: string;
    label: string;
    value: string;
    unit?: string | null;
    type?: 'text' | 'number' | 'boolean';
    group?: string | null;
    note?: string | null;
    order?: number;
};

/** Chuẩn hoá specs về mảng SpecItem[] an toàn */
function toSpecArray(input: any): SpecItem[] {
    if (!input) return [];
    if (Array.isArray(input)) {
        // lọc phần tử rỗng/null và ép kiểu lỏng
        return (input as any[]).filter(Boolean) as SpecItem[];
    }
    // nếu lỡ lưu object {} thì convert thành []
    if (typeof input === 'object') return [];
    return [];
}

/** Sắp xếp specs theo order tăng dần (mặc định 0) */
function sortSpecs(specs: SpecItem[]): SpecItem[] {
    return [...specs].sort((a, b) => (a?.order ?? 0) - (b?.order ?? 0));
}

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

    /** Lấy specs ở cấp Product để fallback khi variant chưa có specs */
    /** Lấy specs ở cấp Product để fallback khi variant chưa có specs */
    private async getProductSpecs(productId: number): Promise<SpecItem[]> {
        // Hiện tại không dùng specs ở cấp Product nữa → fallback rỗng
        return [];
    }

    // ⚙️ LẤY DANH SÁCH BIẾN THỂ (kèm giá & thuộc tính & specs)
    async list(productId: number, q: ListVariantsQuery) {
        const page = Number(q.page ?? 1);
        const limit = Number(q.limit ?? 20);
        const offset = (page - 1) * limit;

        let qb = this.baseQB(productId);
        if (q.status !== undefined) qb = qb.andWhere('v.status = :status', { status: q.status });
        if (q.search) {
            qb = qb.andWhere('(v.variantName ILIKE :kw OR v.sku ILIKE :kw)', { kw: `%${q.search}%` });
        }

        const [entities, total] = await qb
            .orderBy('v.variantId', 'ASC')
            .offset(offset)
            .limit(limit)
            .getManyAndCount();

        // 🔁 chuẩn hoá specs & attributes
        const productSpecsFallback = await this.getProductSpecs(productId);

        const items = entities.map((v) => {
            const variantSpecs = sortSpecs(toSpecArray((v as any).specs));
            const normalizedSpecs = variantSpecs.length > 0 ? variantSpecs : productSpecsFallback;

            return {
                ...v,
                attributes: v.attributes ?? {},
                specs: normalizedSpecs, // <-- đảm bảo luôn có mảng specs hợp lệ
            };
        });

        // 💰 Lồng giá hiện hành (tuỳ chọn)
        if (q.withPrice === 'true' && items.length > 0) {
            const variantIds = items.map((v) => v.variantId);
            const rows = await this.variantsRepo.query(
                `
        WITH cur AS (
          SELECT p.variant_id, p.price, p.price_type, p.currency_code, p.start_at
          FROM public.product_variant_prices p
          WHERE p.variant_id = ANY($1)
            AND p.start_at <= NOW()
            AND (p.end_at IS NULL OR p.end_at > NOW())
        ),
        ranked AS (
          SELECT c.*,
                 ROW_NUMBER() OVER (
                   PARTITION BY c.variant_id
                   ORDER BY 
                     CASE WHEN c.price_type = 'promo' THEN 0
                          WHEN c.price_type = 'base'  THEN 1
                          ELSE 2 END,
                     c.start_at DESC
                 ) AS rn
          FROM cur c
        )
        SELECT variant_id, price, price_type, currency_code
        FROM ranked
        WHERE rn = 1;
        `,
                [variantIds],
            );

            const priceMap = new Map<number, { price: number; price_type: string; currency_code: string }>();
            rows.forEach((r: any) =>
                priceMap.set(Number(r.variant_id), {
                    price: Number(r.price),
                    price_type: r.price_type,
                    currency_code: r.currency_code,
                }),
            );

            items.forEach((it) => {
                const m = priceMap.get(it.variantId);
                (it as any).currentPrice = m?.price ?? null;
                (it as any).currentPriceType = m?.price_type ?? null;
                (it as any).currency = m?.currency_code ?? 'VND';
            });
        }

        return { page, limit, total, items };
    }

    // ⚙️ LẤY 1 VARIANT (kèm thuộc tính + giá + specs)
    async findOne(productId: number, variantId: number) {
        const variant = await this.variantsRepo
            .createQueryBuilder('v')
            .where('v.productId = :productId', { productId })
            .andWhere('v.variantId = :variantId', { variantId })
            .getOne();

        if (!variant) throw new NotFoundException('Variant not found');

        // 💡 chuẩn hoá specs + fallback
        const variantSpecs = sortSpecs(toSpecArray((variant as any).specs));
        const productSpecsFallback =
            variantSpecs.length > 0 ? [] : await this.getProductSpecs(productId);

        // Giá hiện hành (giống list)
        const priceRows = await this.variantsRepo.query(
            `
      WITH cur AS (
        SELECT p.variant_id, p.price, p.price_type, p.currency_code, p.start_at
        FROM public.product_variant_prices p
        WHERE p.variant_id = $1
          AND p.start_at <= NOW()
          AND (p.end_at IS NULL OR p.end_at > NOW())
      ),
      ranked AS (
        SELECT c.*,
               ROW_NUMBER() OVER (
                 PARTITION BY c.variant_id
                 ORDER BY 
                   CASE WHEN c.price_type = 'promo' THEN 0
                        WHEN c.price_type = 'base'  THEN 1
                        ELSE 2 END,
                   c.start_at DESC
               ) AS rn
        FROM cur c
      )
      SELECT variant_id, price, price_type, currency_code
      FROM ranked
      WHERE rn = 1;
      `,
            [variantId],
        );
        const price = priceRows?.[0];

        return {
            ...variant,
            attributes: variant.attributes ?? {},
            specs: variantSpecs.length > 0 ? variantSpecs : productSpecsFallback,
            currentPrice: price ? Number(price.price) : null,
            currentPriceType: price?.price_type ?? null,
            currency: price?.currency_code ?? 'VND',
        };
    }

    // ⚙️ TẠO MỚI
    async create(productId: number, dto: CreateProductVariantDto) {
        const entity = this.variantsRepo.create({
            ...dto,
            status: dto.status ?? 1,
            specs: dto.specs ?? [],
        });
        return this.variantsRepo.save(entity);
    }

    // ⚙️ CẬP NHẬT
    async update(productId: number, variantId: number, dto: UpdateProductVariantDto) {
        const found = await this.findOne(productId, variantId);
        const merged = this.variantsRepo.merge(found as any, dto);
        return this.variantsRepo.save(merged);
    }

    // ⚙️ XOÁ CỨNG
    async remove(productId: number, variantId: number) {
        const found = await this.findOne(productId, variantId);
        await this.variantsRepo.delete((found as any).variantId);
        return { success: true };
    }

    // ⚙️ XOÁ MỀM / DEACTIVATE
    async deactivate(productId: number, variantId: number) {
        const found = await this.findOne(productId, variantId);
        (found as any).status = 0;
        return this.variantsRepo.save(found as any);
    }
}
