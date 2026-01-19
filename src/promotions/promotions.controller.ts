import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Put,
  Delete,
  ParseIntPipe,
  BadRequestException,
  Query,
} from '@nestjs/common';
import { PromotionsService } from './promotions.service';
import { Promotion } from './entities/promotion.entity';

@Controller('promotions')
export class PromotionsController {
  constructor(private readonly promotionsService: PromotionsService) { }

  @Post()
  create(@Body() body: Partial<Promotion>) {
    return this.promotionsService.create(body);
  }

  @Get()
  findAll(
    @Query('isActive') isActive?: string,
  ) {
    return this.promotionsService.findAll(
      isActive !== undefined ? isActive === 'true' : undefined,
    );
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.promotionsService.findOne(id);
  }

  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() body: Partial<Promotion>,
  ) {
    return this.promotionsService.update(id, body);
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.promotionsService.remove(id);
  }

  @Post(':id/apply')
  addApplicability(
    @Param('id', ParseIntPipe) id: number,
    @Body() body: { productId?: number; categoryId?: number },
  ) {
    if (
      (body.productId && typeof body.productId !== 'number') ||
      (body.categoryId && typeof body.categoryId !== 'number')
    ) {
      throw new BadRequestException('productId / categoryId must be number');
    }

    return this.promotionsService.addApplicability(
      id,
      body.productId,
      body.categoryId,
    );
  }

  @Get(':id/apply')
  getApplicability(@Param('id', ParseIntPipe) id: number) {
    return this.promotionsService.getApplicability(id);
  }

  @Delete(':id/apply/:applyId')
  removeApplicability(
    @Param('id', ParseIntPipe) id: number,
    @Param('applyId', ParseIntPipe) applyId: number,
  ) {
    return this.promotionsService.removeApplicability(id, applyId);
  }

  @Post('voucher')
  createVoucher(@Body() body: Partial<Promotion>) {
    return this.promotionsService.createVoucher(body);
  }

  /**
   * 🔍 Validate voucher khi checkout
   */
  @Post('apply-voucher')
  validateVoucher(
    @Body()
    body: {
      code: string;
      orderTotal: number;
    },
  ) {
    if (!body.code) {
      throw new BadRequestException('Thiếu mã voucher');
    }

    if (body.orderTotal == null) {
      throw new BadRequestException('Thiếu tổng tiền đơn hàng');
    }

    return this.promotionsService.applyVoucher(
      body.code,
      Number(body.orderTotal),
    );
  }

  /**
   * 📋 Danh sách voucher
   */
  @Get()
  getAllVouchers() {
    return this.promotionsService.findAllVouchers();
  }

  /**
   * 📄 Chi tiết voucher theo code
   */
  @Get(':code')
  getVoucherByCode(@Param('code') code: string) {
    return this.promotionsService.getVoucherByCode(code);
  }
}
