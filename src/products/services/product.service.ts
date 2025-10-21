import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Product } from '../entities/product.entity';
import { CreateProductDto } from '../dto/create-product.dto';
import { ProductImage } from '../entities/product-image.entity';
import { Category } from 'src/categories/entities/category.entity';

@Injectable()
export class ProductService {
  constructor(
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,

    @InjectRepository(ProductImage)
    private readonly imageRepo: Repository<ProductImage>,

    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,

    private readonly ds: DataSource
  ) { }

  // Helper: map DTO -> Partial<Product> (đúng shape entity, đặc biệt JSONB & category)
  private mapDtoToEntityPartial(dto: Partial<CreateProductDto>): Partial<Product> {
    const patch: Partial<Product> = {
      product_name: dto.product_name,
      short_description: dto.short_description ?? undefined,
      long_description: dto.long_description ?? undefined,
      status: dto.status ?? undefined,
      price: (dto.price as any) ?? undefined,          // numeric transformer xử lý
      stock_quantity: dto.stock_quantity ?? undefined,
      // JSONB
      specs: dto.specs ?? undefined,                   // object | undefined
      origin: dto.origin ?? undefined,                 // string | undefined
      user_manual:
        dto.user_manual === undefined
          ? undefined
          : (dto.user_manual
            ? {
              pdf: dto.user_manual.pdf,
              video: dto.user_manual.video,
              steps: dto.user_manual.steps ?? [],
            }
            : null),
      caution_notes: dto.caution_notes ?? undefined,   // string[] | undefined
    };

    // Quan hệ Category: nếu có category_id thì gán quan hệ, nếu không truyền gì thì không đổi
    if (dto.category_id !== undefined) {
      patch.category = dto.category_id ? ({ category_id: dto.category_id } as any) : null;
    }

    return patch;
  }

  async create(createProductDto: CreateProductDto): Promise<Product> {
    const { images, category_id, ...rest } = createProductDto;

    // Giữ nguyên hành vi: yêu cầu category phải tồn tại
    const category = await this.categoryRepo.findOneBy({ category_id });
    if (!category) {
      throw new Error(`Category with id ${category_id} not found`);
    }
    let sku = (createProductDto as any).sku?.trim();
    if (!sku) sku = makeSku(rest.product_name);
    // Map DTO -> entity (đặt default hợp lý cho JSONB để tránh null)
    const entity: Partial<Product> = {
      ...this.mapDtoToEntityPartial(rest),
      category,
      specs: rest.specs ?? {},                 // default {}
      user_manual: rest.user_manual
        ? { pdf: rest.user_manual.pdf, video: rest.user_manual.video, steps: rest.user_manual.steps ?? [] }
        : null,                                // cho phép null
      caution_notes: rest.caution_notes ?? [], // default []
      sku,
    };

    const product = this.productRepo.create(entity);
    await this.productRepo.save(product);

    // Lưu images (nếu có)
    if (images?.length) {
      const productImages = images.map((image) =>
        this.imageRepo.create({ ...image, product })
      );
      await this.imageRepo.save(productImages);
    }

    // Load lại product kèm quan hệ
    const productWithRelations = await this.productRepo.findOne({
      where: { product_id: product.product_id },
      relations: ['category', 'images'],
    });
    if (!productWithRelations) throw new Error('Product not found after creation');
    return productWithRelations;
  }

  async findAll(): Promise<Product[]> {
    return this.productRepo.find({
      relations: ['images', 'category'],
      order: { created_at: 'DESC' },
    });
  }

  async findOne(id: number): Promise<Product | null> {
    return this.productRepo.findOne({
      where: { product_id: id },
      relations: ['images', 'category'],
      // (order không ảnh hưởng findOne; bỏ cũng được. Giữ nguyên hành vi trả 1 bản ghi)
    });
  }

  async update(id: number, data: Partial<CreateProductDto>): Promise<Product | null> {
    // Map DTO -> Partial<Product> đúng shape (tránh truyền class DTO trực tiếp)
    const patch = this.mapDtoToEntityPartial(data);
    await this.productRepo.update(id, patch);
    return this.findOne(id);
  }

  async remove(id: number): Promise<void> {
    await this.productRepo.delete(id);
  }

  async findAllPaginated(page = 1, limit = 10): Promise<[Product[], number]> {
    return this.productRepo.findAndCount({
      relations: ['images', 'category'],
      order: { created_at: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });
  }

  async searchProducts(q: string, page = 1, limit = 10) {
    const term = (q ?? '').trim();
    if (!term) {
      return { items: [], pagination: { page, limit, total: 0, pages: 0 } };
    }
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
export function makeSku(productName: string): string {
  const base = (productName || 'PROD')
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')     // bỏ dấu tiếng Việt
    .replace(/[^a-zA-Z0-9]+/g, '-')      // non-alnum -> -
    .replace(/^-+|-+$/g, '')             // trim -
    .toUpperCase()
    .slice(0, 20);                        // giới hạn độ dài

  const ts = Date.now().toString().slice(-6); // 6 số cuối
  return `${base || 'PROD'}-${ts}`;
}