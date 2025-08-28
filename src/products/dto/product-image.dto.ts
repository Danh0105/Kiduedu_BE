import { IsBoolean, IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateProductImageDto {
  @Type(() => Number)
  @IsNumber()
  @IsNotEmpty()
  product_id: number;

  @IsString()
  @IsNotEmpty()
  image_url: string;

  @IsString()
  @IsOptional()
  alt_text?: string;

  @IsBoolean()
  @IsOptional()
  is_primary?: boolean;
}
