import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { plainToInstance } from 'class-transformer';
import { Product } from '../entities/product.entity';
import { ProductImage } from '../entities/product-image.entity';
import { ProductVariant } from '../entities/product-variant.entity';
import { Category } from '../../categories/entities/category.entity';
import { CreateProductDto } from '../dto/create-product.dto';
import { ProductResponseDto } from '../dto/ProductResponse.dto';

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
      specs: dto.specs ?? {},
      origin: dto.origin ?? null,
      userManual: dto.user_manual
        ? {
          pdf: dto.user_manual.pdf,
          video: dto.user_manual.video,
          steps: dto.user_manual.steps ?? [],
        }
        : null,
      cautionNotes: dto.caution_notes ?? [],
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

    // Kiểm tra danh mục tồn tại
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

    // Tạo sản phẩm chính
    const productEntity = this.productRepo.create({
      ...this.mapDtoToEntity(rest),
      category,
    });

    const savedProduct = await this.productRepo.save(productEntity);

    // 🖼️ Lưu ảnh sản phẩm (nếu có)
    if (images?.length) {
      const imageEntities = images.map((img) =>
        this.imageRepo.create({ ...img, product: savedProduct }),
      );
      await this.imageRepo.save(imageEntities);
    }

    // 🧩 Lưu các biến thể (variants) nếu có
    if (variants?.length) {
      const variantEntities = variants.map((v) =>
        this.variantRepo.create({
          ...v,
          product: savedProduct,
        }),
      );
      await this.variantRepo.save(variantEntities);
    }

    // Load lại với quan hệ đầy đủ
    const productWithRelations = await this.productRepo.findOne({
      where: { productId: savedProduct.productId },
      relations: ['category', 'images', 'variants'],
    });

    return productWithRelations!;
  }

  /** 🔍 Lấy chi tiết 1 sản phẩm (đầy đủ quan hệ) */
  async findDetailed(productId: number): Promise<ProductResponseDto> {
    const product = await this.productRepo.findOne({
      where: { productId },
      relations: [
        'category',
        'images',
        'variants',
        'variants.images', // lấy luôn ảnh variant
      ],
    });

    if (!product) {
      throw new NotFoundException(`Product ${productId} không tồn tại`);
    }

    return plainToInstance(ProductResponseDto, product, {
      excludeExtraneousValues: true,
    });
  }

  /** ✏️ Cập nhật sản phẩm */
  async update(id: number, dto: Partial<CreateProductDto>): Promise<Product> {
    const existing = await this.productRepo.findOne({
      where: { productId: id },
    });
    if (!existing) throw new NotFoundException(`Product ${id} không tồn tại`);

    const patch = this.mapDtoToEntity(dto);
    await this.productRepo.update(id, patch);
    return (await this.findOne(id))!;
  }

  /** 🗑️ Xoá sản phẩm */
  async remove(id: number): Promise<void> {
    const existing = await this.productRepo.findOne({
      where: { productId: id },
    });
    if (!existing) throw new NotFoundException(`Product ${id} không tồn tại`);

    await this.productRepo.delete(id);
  }

  /** 🔍 Lấy sản phẩm đơn giản (không join phức tạp) */
  async findOne(id: number): Promise<Product | null> {
    return this.productRepo.findOne({
      where: { productId: id },
      relations: ['images', 'category', 'variants'],
    });
  }

  /** 📄 Phân trang sản phẩm */
  async findAllPaginated(
    page = 1,
    limit = 10,
  ): Promise<{ items: Product[]; total: number; pages: number }> {
    const [items, total] = await this.productRepo.findAndCount({
      relations: ['images', 'category', 'variants'],
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    return { items, total, pages: Math.ceil(total / limit) };
  }

  /** 🔎 Tìm kiếm toàn văn (Full-text search Postgres) */
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
