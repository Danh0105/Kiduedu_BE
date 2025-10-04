// src/search/search-products.dto.ts
import { IsInt, IsOptional, IsString, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class SearchProductsDto {
  @IsOptional()
  @IsString()
  q?: string;                 // <-- KHÔNG dùng @IsNotEmpty()

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page: number = 1;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit: number = 12;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  category_id?: number;       // lọc theo danh mục (cha hoặc con)
}
