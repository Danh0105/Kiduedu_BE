// create-category.dto.ts
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreateCategoryDto {
  @IsString()
  @IsNotEmpty()
  categoryName: string;

  @IsString()
  @IsOptional()
  description?: string | null;

  @IsOptional()
  parentCategoryId?: number | null;
}
