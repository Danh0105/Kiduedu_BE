import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Product } from './entities/product.entity';
import { CreateProductDto } from './dto/create-product.dto';
import { ProductImage } from './entities/product-image.entity';
import { Category } from 'src/categories/entities/category.entity';

@Injectable()
export class ProductService {
  constructor(
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,

    @InjectRepository(ProductImage)
    private readonly imageRepo: Repository<ProductImage>, // ✅ thêm decorator

    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>, // ✅ thêm decorator
    private readonly ds: DataSource
  ) { }


  async create(createProductDto: CreateProductDto): Promise<Product> {
    const { images, category_id, ...productData } = createProductDto;

    // ✅ Lấy category từ DB
    const category = await this.categoryRepo.findOneBy({ category_id: category_id });
    if (!category) {
      throw new Error(`Category with id ${category_id} not found`);
    }

    // ✅ Tạo product
    const product = this.productRepo.create({
      ...productData,
      category,
    });
    await this.productRepo.save(product);

    // ✅ Lưu images (nếu có)
    if (images?.length) {
      const productImages = images.map(image =>
        this.imageRepo.create({ ...image, product })
      );
      await this.imageRepo.save(productImages);
    }

    // ✅ Load lại product kèm quan hệ category + images
    const productWithRelations = await this.productRepo.findOne({
      where: { product_id: product.product_id },
      relations: ["category", "images"], // <-- thêm quan hệ
    });
    if (!productWithRelations) {
      throw new Error("Product not found after creation");
    }
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
      order: { created_at: 'DESC' },

    });
  }

  async update(id: number, data: Partial<CreateProductDto>): Promise<Product | null> {
    await this.productRepo.update(id, data);
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

    // ITEMS
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

    // TOTAL
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