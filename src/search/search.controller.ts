// src/search/search.controller.ts
import { Controller, Get, Query, UsePipes, ValidationPipe } from '@nestjs/common';
import { SearchService } from './search.service';
import { SearchProductsDto } from './search-products.dto';

@Controller('search')
export class SearchController {
  constructor(private readonly searchService: SearchService) { }

  @Get('products')
  @UsePipes(new ValidationPipe({ transform: true, whitelist: true }))
  async searchProducts(@Query() dto: SearchProductsDto) {
    return this.searchService.searchProducts(dto.q ?? "", dto.page, dto.limit, dto.category_id);
  }
}
