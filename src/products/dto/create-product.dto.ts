import { IsNotEmpty, IsNumber, IsOptional, IsString, IsIn } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateProductDto {
  @IsString()
  @IsNotEmpty()
  product_name: string;

  @IsString()
  @IsNotEmpty()
  sku: string;

  @IsString()
  @IsOptional()
  description?: string;

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

  @IsString()
  @IsIn(['computer', 'refrigeration', 'robotics'])
  @IsOptional()
  product_type?: 'computer' | 'refrigeration' | 'robotics';
}
