import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Product } from '../entities/product.entity';
import { ProductImage } from '../entities/product-image.entity';
import { ProductVariant } from '../entities/product-variant.entity';
import { Category } from '../../categories/entities/category.entity';
import { CreateProductDto } from '../dto/create-product.dto';

/* =========================== Helpers =========================== */
// Ưu tiên kiểu giá: sale → promo → retail → base
const PRICE_PRIORITY = ['sale', 'promo', 'retail', 'base'] as const;
type PriceType = typeof PRICE_PRIORITY[number];
type UserManual =
  | string
  | { pdf?: string; video?: string; steps?: string[] }
  | null;

function normalizeUserManual(input: any): { pdf?: string; video?: string; steps: string[] } | null {
  if (input == null) return null;

  // Trường hợp DB đang lưu chuỗi thuần
  if (typeof input === 'string') {
    // Tuỳ bạn muốn: coi như 1 bước duy nhất, hoặc đưa vào field khác
    return { steps: [input] };
  }

  // Trường hợp object JSONB đúng chuẩn/bán chuẩn
  if (typeof input === 'object' && !Array.isArray(input)) {
    const pdf = typeof input.pdf === 'string' ? input.pdf : undefined;
    const video = typeof input.video === 'string' ? input.video : undefined;
    const steps = Array.isArray(input.steps)
      ? (input.steps.filter((s: any) => typeof s === 'string') as string[])
      : [];
    return { pdf, video, steps };
  }

  // Các trường hợp còn lại (mảng, số, bool, …) → bỏ qua
  return null;
}

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

function toArray<T = any>(v: any): T[] {
  if (!v) return [];
  return Array.isArray(v) ? (v as T[]) : [];
}
function toObject<T extends object = Record<string, any>>(v: any): T {
  if (!v || typeof v !== 'object' || Array.isArray(v)) return {} as T;
  return v as T;
}
function toSpecArray(input: any): SpecItem[] {
  if (!input) return [];
  if (Array.isArray(input)) return (input as any[]).filter(Boolean) as SpecItem[];
  if (typeof input === 'object') return []; // nếu lỡ lưu {} thì coi như rỗng
  return [];
}
function sortSpecs(specs: SpecItem[]): SpecItem[] {
  return [...specs].sort((a, b) => (a?.order ?? 0) - (b?.order ?? 0));
}

/** Chọn giá hiện hành từ mảng prices đã load qua quan hệ */
function pickCurrentPrice(prices: any[]): any | null {
  if (!Array.isArray(prices) || prices.length === 0) return null;

  const now = new Date();
  const active = prices.filter((p) => {
    const startOk = p.startAt ? new Date(p.startAt) <= now : true;
    const endOk = p.endAt ? new Date(p.endAt) > now : true;
    return startOk && endOk;
  });

  const list = (active.length ? active : []) as any[];

  if (list.length === 0) return null;

  // sort theo: type priority → startAt desc
  list.sort((a, b) => {
    const pa = PRICE_PRIORITY.indexOf((a.priceType as PriceType) ?? 'base');
    const pb = PRICE_PRIORITY.indexOf((b.priceType as PriceType) ?? 'base');
    if (pa !== pb) return pa - pb;
    const sa = a.startAt ? new Date(a.startAt).getTime() : 0;
    const sb = b.startAt ? new Date(b.startAt).getTime() : 0;
    return sb - sa;
  });

  return list[0];
}
/* =============================================================== */

@Injectable()
export class ProductService {
  constructor(
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,

    @InjectRepository(ProductImage)
    private readonly imageRepo: Repository<ProductImage>,

    @InjectRepository(ProductVariant)
    private readonly variantRepo: Repository<ProductVariant>,

    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,

    private readonly ds: DataSource,
  ) { }

  /** 🧩 Helper: map DTO → entity (chuẩn hoá key & nullable fields) */
  private mapDtoToEntity(dto: Partial<CreateProductDto>): Partial<Product> {
    const patch: Partial<Product> = {
      productName: dto.product_name,
      shortDescription: dto.short_description ?? null,
      longDescription: dto.long_description ?? null,
      status: dto.status ?? 1,
      origin: dto.origin ?? null,

      // ⬇️ CHỈNH: chấp nhận string hoặc object
      userManual:
        dto.user_manual !== undefined
          ? normalizeUserManual(dto.user_manual)
          : null,

      cautionNotes: Array.isArray(dto.caution_notes) ? dto.caution_notes : [],
    };

    if (dto.category_id !== undefined) {
      patch.category = dto.category_id
        ? ({ categoryId: dto.category_id } as any)
        : null;
    }
    return patch;
  }


  /** 🆕 Tạo mới sản phẩm (kèm ảnh và biến thể) */
  async create(createProductDto: CreateProductDto): Promise<Product> {
    const { images, variants, category_id, ...rest } = createProductDto;

    let category: Category | null = null;
    if (category_id) {
      category = await this.categoryRepo.findOne({
        where: { categoryId: category_id },
      });
      if (!category) {
        throw new NotFoundException(
          `Category với ID ${category_id} không tồn tại`,
        );
      }
    }

    const productEntity = this.productRepo.create({
      ...this.mapDtoToEntity(rest),
      category,
    });

    const savedProduct = await this.productRepo.save(productEntity);

    // 🖼️ Ảnh sản phẩm
    if (images?.length) {
      const imageEntities = images.map((img) =>
        this.imageRepo.create({ ...img, product: savedProduct }),
      );
      await this.imageRepo.save(imageEntities);
    }

    // 🧩 Biến thể
    if (variants?.length) {
      const variantEntities = variants.map((v) =>
        this.variantRepo.create({
          ...v,
          attributes: toObject(v.attributes),
          specs: sortSpecs(toSpecArray((v as any).specs)),
          product: savedProduct,
        }),
      );
      await this.variantRepo.save(variantEntities);
    }

    const productWithRelations = await this.productRepo.findOne({
      where: { productId: savedProduct.productId },
      relations: ['category', 'images', 'variants'],
    });

    return productWithRelations!;
  }

  /** ✏️ Cập nhật */
  async update(id: number, dto: Partial<CreateProductDto>): Promise<Product> {
    const existing = await this.productRepo.findOne({
      where: { productId: id },
    });
    if (!existing) throw new NotFoundException(`Product ${id} không tồn tại`);

    const patch = this.mapDtoToEntity(dto);
    await this.productRepo.update(id, patch);
    return (await this.findOne(id))!;
  }

  /** 🗑️ Xoá */
  async remove(id: number): Promise<void> {
    const existing = await this.productRepo.findOne({
      where: { productId: id },
    });
    if (!existing) throw new NotFoundException(`Product ${id} không tồn tại`);
    await this.productRepo.delete(id);
  }

  /**
   * 🔍 Lấy thông tin 1 sản phẩm CHI TIẾT:
   * - product + category + images
   * - variants (đủ trường, chuẩn hoá attributes/specs)
   * - variant.prices (toàn bộ lịch sử giá) + currentPrice tính sẵn
   */
  async findOne(id: number): Promise<Product | null> {
    // Load đầy đủ quan hệ cần thiết (bao gồm prices của từng variant)
    const product = await this.productRepo.findOne({
      where: { productId: id },
      relations: [
        'category',
        'images',
        'variants',
        'variants.prices', // <-- quan trọng để có toàn bộ variant_price
      ],

    });

    if (!product) return null;

    // Chuẩn hoá các trường JSONB cấp Product để FE đỡ null-check
    // @ts-ignore
    product.cautionNotes = toArray((product as any).cautionNotes);
    // @ts-ignore
    /* if ((product as any).userManual) {
      // @ts-ignore
      (product as any).userManual.steps = toArray((product as any).userManual.steps);
    } */
    product.userManual = normalizeUserManual((product as any).userManual);
    // Nếu không có variants thì trả về luôn
    if (!product.variants || product.variants.length === 0) return product;

    // Gắn currentPrice + chuẩn hoá specs/attributes cho từng variant
    product.variants = product.variants.map((variant: any) => {
      // chuẩn hoá JSONB
      const normalizedAttrs = toObject(variant.attributes);
      const normalizedSpecs = sortSpecs(toSpecArray(variant.specs));

      // sắp xếp toàn bộ lịch sử giá (mới → cũ) để FE xem timeline
      const allPrices = toArray<any>(variant.prices).slice().sort((a, b) => {
        const ta = a.startAt ? new Date(a.startAt).getTime() : 0;
        const tb = b.startAt ? new Date(b.startAt).getTime() : 0;
        return tb - ta;
      });

      const cur = pickCurrentPrice(allPrices);

      return {
        ...variant,
        attributes: normalizedAttrs,
        specs: normalizedSpecs,
        prices: allPrices,             // toàn bộ variant_price
        currentPrice: cur?.price ?? null,
        currentPriceType: cur?.priceType ?? null,
        currency: cur?.currencyCode ?? 'VND',
      };
    });

    return product;
  }

  /** 📄 Phân trang (nhẹ): product + category + variants (không load prices để nhẹ) */
  async findAllPaginated(
    page = 1,
    limit = 10,
  ): Promise<{ items: Product[]; total: number; pages: number }> {
    const [items, total] = await this.productRepo.findAndCount({
      relations: ['category', 'variants'],
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    // chuẩn hoá tối thiểu để FE đỡ null-check
    const normalized = items.map((p: any) => {
      p.cautionNotes = Array.isArray(p.cautionNotes) ? p.cautionNotes : [];
      p.userManual = normalizeUserManual(p.userManual); // ⬅️ thêm dòng này
      p.variants = (p.variants || []).map((v: any) => ({
        ...v,
        attributes: typeof v.attributes === 'object' && !Array.isArray(v.attributes) ? v.attributes : {},
        specs: Array.isArray(v.specs) ? v.specs : [],
      }));
      return p;
    });


    return { items: normalized as any, total, pages: Math.ceil(total / limit) };
  }

  /** 🔎 Tìm kiếm full-text (giữ nguyên) */
  async searchProducts(q: string, page = 1, limit = 10) {
    const term = (q ?? '').trim();
    if (!term)
      return { items: [], pagination: { page, limit, total: 0, pages: 0 } };

    const offset = (page - 1) * limit;

    const items = await this.ds.query(
      `
      WITH q AS (
        SELECT public.unaccent_imm($1) AS uq,
               websearch_to_tsquery('simple', public.unaccent_imm($1)) AS tsq
      )
      SELECT
        p.product_id,
        p.product_name,
        ts_rank_cd(p.search_vec, q.tsq, 32) AS rank,
        img.image_url AS image_url
      FROM public.products p
      CROSS JOIN q
      LEFT JOIN LATERAL (
        SELECT pi.image_url
        FROM public.product_images pi
        WHERE pi.product_id = p.product_id
        ORDER BY pi.is_primary DESC, pi.image_id ASC
        LIMIT 1
      ) AS img ON TRUE
      WHERE (p.search_vec @@ q.tsq)
         OR public.unaccent_imm(p.product_name) ILIKE '%' || q.uq || '%'
      ORDER BY rank DESC, p.product_id
      LIMIT $2 OFFSET $3
      `,
      [term, limit, offset],
    );

    const totalRes = await this.ds.query(
      `
      WITH q AS (
        SELECT public.unaccent_imm($1) AS uq,
               websearch_to_tsquery('simple', public.unaccent_imm($1)) AS tsq
      )
      SELECT COUNT(*)::int AS count
      FROM public.products p, q
      WHERE (p.search_vec @@ q.tsq)
         OR public.unaccent_imm(p.product_name) ILIKE '%' || q.uq || '%'
      `,
      [term],
    );

    const total: number = totalRes?.[0]?.count ?? 0;

    return {
      items,
      pagination: { page, limit, total, pages: Math.ceil(total / limit) },
    };
  }
}
