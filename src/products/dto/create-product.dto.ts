// src/products/dto/create-product.dto.ts
import {
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  IsInt,
  IsArray,
  ValidateNested,
  IsObject,
} from 'class-validator';
import { Type } from 'class-transformer';
import { CreateProductImageDto } from './product-image.dto';
import { UserManualDto } from './user-manual.dto';

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

  // ====== BỔ SUNG 4 CỘT ======

  // specs: JSONB tự do (key/value)
  @IsOptional()
  @IsObject()
  specs?: Record<string, any>;

  // origin: text ngắn
  @IsOptional()
  @IsString()
  origin?: string;

  // user_manual: object có validate riêng
  @IsOptional()
  @ValidateNested()
  @Type(() => UserManualDto)
  user_manual?: UserManualDto;

  // caution_notes: mảng string
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  caution_notes?: string[];
}
