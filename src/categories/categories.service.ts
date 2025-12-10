import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Category } from './entities/category.entity';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,
  ) { }

  /** 🆕 Tạo danh mục mới */
  async create(dto: CreateCategoryDto): Promise<Category> {

    const category = this.categoryRepo.create({
      categoryName: dto.categoryName,

      description: dto.description?.trim() || null,
    });

    // Nếu có parent_category_id -> liên kết danh mục cha
    if (dto.parentCategoryId) {
      const parent = await this.categoryRepo.findOne({
        where: { categoryId: dto.parentCategoryId },
      });
      if (!parent) {
        throw new NotFoundException(
          `Parent category ID ${dto.parentCategoryId} không tồn tại.`,
        );
      }
      category.parent = parent;
    }

    return this.categoryRepo.save(category);
  }

  /** 📜 Lấy toàn bộ danh mục */
  async findAll(): Promise<Category[]> {
    return this.categoryRepo.find({
      relations: ['parent', 'children', 'products'],
      order: { categoryName: 'ASC' },
    });
  }

  /** 🔍 Lấy chi tiết một danh mục */
  async findOne(id: number): Promise<Category> {
    const category = await this.categoryRepo.findOne({
      where: { categoryId: id },
      relations: ['parent', 'children'],
    });
    if (!category) {
      throw new NotFoundException(`Category ID ${id} không tồn tại.`);
    }
    return category;
  }

  /** ✏️ Cập nhật danh mục */
  async update(id: number, dto: UpdateCategoryDto): Promise<Category> {
    const category = await this.findOne(id);

    if (dto.categoryName !== undefined)
      category.categoryName = dto.categoryName;
    if (dto.description !== undefined)
      category.description = dto.description;

    if (dto.parentCategoryId !== undefined) {
      if (dto.parentCategoryId === null) {
        category.parent = null;
      } else {
        const parent = await this.categoryRepo.findOne({
          where: { categoryId: dto.parentCategoryId },
        });
        if (!parent)
          throw new NotFoundException(
            `Parent category ID ${dto.parentCategoryId} không tồn tại.`,
          );
        category.parent = parent;
      }
    }

    return this.categoryRepo.save(category);
  }
  async partialUpdate(id: number, dto: Partial<UpdateCategoryDto>): Promise<Category> {
    const cat = await this.categoryRepo.findOne({ where: { categoryId: id } });
    if (!cat) throw new NotFoundException();

    this.categoryRepo.merge(cat, dto);
    return this.categoryRepo.save(cat);
  }

  /** 🗑️ Xoá danh mục */
  async remove(id: number): Promise<void> {
    const category = await this.findOne(id);
    await this.categoryRepo.remove(category);
  }
}
