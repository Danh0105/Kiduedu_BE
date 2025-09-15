import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
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

}