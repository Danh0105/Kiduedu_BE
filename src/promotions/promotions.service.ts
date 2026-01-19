import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
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

  /* ================= PROMOTION ================= */

  async create(data: Partial<Promotion>): Promise<Promotion> {
    const promo = this.promotionRepo.create(data);
    return this.promotionRepo.save(promo);
  }

  async findAll(isActive?: boolean): Promise<Promotion[]> {
    const where: any = {};

    if (typeof isActive === 'boolean') {
      where.isActive = isActive;
    }

    return this.promotionRepo.find({
      where,
      relations: ['applicability', 'applicability.product', 'applicability.product.variants'],
      order: { startDate: 'DESC' },
    });
  }


  async findOne(id: number): Promise<Promotion> {
    const promo = await this.promotionRepo.findOne({
      where: { id },
      relations: ['applicability'],
    });
    if (!promo) throw new NotFoundException('Promotion not found');
    return promo;
  }

  async update(id: number, data: Partial<Promotion>): Promise<Promotion> {
    if (!data || Object.keys(data).length === 0) {
      throw new BadRequestException('No fields to update');
    }

    const promo = await this.findOne(id);
    Object.assign(promo, data);

    return this.promotionRepo.save(promo);
  }


  async remove(id: number): Promise<void> {
    const promo = await this.findOne(id);
    await this.promotionRepo.remove(promo);
  }

  /* ================= APPLICABILITY ================= */

  async getApplicability(promotionId: number) {
    await this.findOne(promotionId);

    return this.applicabilityRepo.find({
      where: { promotion: { id: promotionId } },
      relations: ['product', 'category'],
    });
  }

  async addApplicability(
    promotionId: number,
    productId?: number,
    categoryId?: number,
  ) {
    if (!!productId === !!categoryId) {
      throw new BadRequestException('Chỉ được chọn product hoặc category');
    }

    await this.findOne(promotionId);

    const where: any = {
      promotion: { id: promotionId },
    };

    if (productId) {
      where.product = { productId: productId };
    }

    if (categoryId) {
      where.category = { categoryId: categoryId };
    }

    const existed = await this.applicabilityRepo.findOne({ where });

    if (existed) {
      throw new ConflictException('Phạm vi đã tồn tại');
    }

    const applicability = this.applicabilityRepo.create({
      promotion: { id: promotionId },
      product: productId ? { productId: productId } : null,
      category: categoryId ? { categoryId: categoryId } : null,
    } as Partial<PromotionApplicability>);


    return this.applicabilityRepo.save(applicability);
  }


  async removeApplicability(
    promotionId: number,
    applicabilityId: number,
  ) {
    const applicability = await this.applicabilityRepo.findOne({
      where: {
        id: applicabilityId,
        promotion: { id: promotionId },
      },
    });

    if (!applicability) {
      throw new NotFoundException('Applicability not found');
    }

    await this.applicabilityRepo.remove(applicability);
  }

  async findAllVouchers() {
    return this.promotionRepo.find({
      where: { isVoucher: true },
      order: { startDate: 'DESC' },
    });
  }

  async getVoucherByCode(code: string) {
    return this.promotionRepo.findOne({
      where: { code, isVoucher: true },
    });
  }

  async createVoucher(data: Partial<Promotion>) {
    const { id, code, usageLimit, } = data;

    if (!id) {
      throw new BadRequestException('Thiếu promotionId');
    }

    if (!code) {
      throw new BadRequestException('Voucher phải có mã');
    }

    // 1️⃣ Kiểm tra promotion tồn tại
    const promotion = await this.promotionRepo.findOne({
      where: { id },
    });

    if (!promotion) {
      throw new NotFoundException('Promotion không tồn tại');
    }

    // 2️⃣ Kiểm tra code trùng
    const existedCode = await this.promotionRepo.findOne({
      where: { code },
    });

    if (existedCode) {
      throw new ConflictException('Mã voucher đã tồn tại');
    }

    // 3️⃣ Update promotion → thành voucher
    promotion.code = code;
    promotion.isVoucher = true;
    promotion.usageLimit = usageLimit ?? null;
    promotion.usedCount = 0;

    return this.promotionRepo.save(promotion);
  }



  async applyVoucher(code: string, orderTotal: number) {
    const voucher = await this.promotionRepo.findOne({
      where: {
        code,
        isVoucher: true,
        isActive: true,
      },
    });

    if (!voucher) {
      throw new BadRequestException('Voucher không tồn tại');
    }

    const now = new Date();
    if (now < voucher.startDate || now > voucher.endDate) {
      throw new BadRequestException('Voucher đã hết hạn');
    }

    if (voucher.usageLimit && voucher.usedCount >= voucher.usageLimit) {
      throw new BadRequestException('Voucher đã hết lượt sử dụng');
    }

    if (voucher.minOrderValue && orderTotal < voucher.minOrderValue) {
      throw new BadRequestException(
        `Đơn hàng tối thiểu ${voucher.minOrderValue.toLocaleString()}₫`,
      );
    }

    return voucher;
  }


}
