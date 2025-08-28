import { Controller, Get, Post, Body, Param, Put, Delete } from '@nestjs/common';
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
  findAll() {
    return this.promotionsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: number) {
    return this.promotionsService.findOne(+id);
  }

  @Put(':id')
  update(@Param('id') id: number, @Body() body: Partial<Promotion>) {
    return this.promotionsService.update(+id, body);
  }

  @Delete(':id')
  remove(@Param('id') id: number) {
    return this.promotionsService.remove(+id);
  }

  @Post(':id/apply')
  addApplicability(
    @Param('id') id: number,
    @Body() body: { productId?: number; categoryId?: number },
  ) {
    return this.promotionsService.addApplicability(id, body.productId, body.categoryId);
  }
}
