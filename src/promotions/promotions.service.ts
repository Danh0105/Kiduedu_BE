import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Promotion } from './entities/promotion.entity';
import { PromotionApplicability } from './entities/promotion-applicability.entity';

@Injectable()
export class PromotionsService {
  constructor(
    @InjectRepository(Promotion)
    private readonly promotionRepo: Repository<Promotion>,
    @InjectRepository(PromotionApplicability)
    private readonly applicabilityRepo: Repository<PromotionApplicability>,
  ) { }

  async create(data: Partial<Promotion>): Promise<Promotion> {
    const promo = this.promotionRepo.create(data);
    return this.promotionRepo.save(promo);
  }

  async findAll(): Promise<Promotion[]> {
    return this.promotionRepo.find({ relations: ['applicability'] });
  }

  async findOne(id: number): Promise<Promotion> {
    const promo = await this.promotionRepo.findOne({
      where: { promotion_id: id },
      relations: ['applicability'],
    });
    if (!promo) throw new NotFoundException('Promotion not found');
    return promo;
  }

  async update(id: number, data: Partial<Promotion>): Promise<Promotion> {
    const promo = await this.findOne(id);
    Object.assign(promo, data);
    return this.promotionRepo.save(promo);
  }

  async remove(id: number): Promise<void> {
    const promo = await this.findOne(id);
    await this.promotionRepo.remove(promo);
  }

  async addApplicability(promotionId: number, productId?: number, categoryId?: number) {
    const promo = await this.findOne(promotionId);
    const applicability = this.applicabilityRepo.create({
      promotion: promo,
      product: productId ? { product_id: productId } as any : null,
      category: categoryId ? { category_id: categoryId } as any : null,
    });
    return this.applicabilityRepo.save(applicability);
  }
}
