import { IsNotEmpty, IsNumber, IsOptional, IsString, IsIn, IsInt, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { CreateProductImageDto } from './product-image.dto';

export class CreateProductDto {
  @IsString()
  @IsNotEmpty()
  product_name: string;

  @IsString()
  @IsOptional()
  short_description?: string;

  @IsString()
  @IsOptional()
  long_description?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  status?: number;

  @Type(() => Number)
  @IsNumber()
  price: number;

  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  stock_quantity?: number;

  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  category_id?: number;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateProductImageDto)
  images: CreateProductImageDto[];
}
