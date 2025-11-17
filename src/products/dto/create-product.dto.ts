import {
  IsNotEmpty,
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
import { CreateProductVariantDto } from './create-product-variant.dto';
import { InitialReceiptDto } from './initial-receipt.dto';

export class CreateProductDto {
  /** 🏷️ Tên sản phẩm */
  @IsString()
  @IsNotEmpty()
  product_name: string;

  /** ✏️ Mô tả ngắn */
  @IsString()
  @IsOptional()
  short_description?: string;

  /** 📄 Mô tả chi tiết */
  @IsString()
  @IsOptional()
  long_description?: string;

  /** ⚙️ Trạng thái (1=active, 0=inactive) */
  @Type(() => Number)
  @IsInt()
  @IsOptional()
  status?: number = 1;

  /** 🗂️ Danh mục sản phẩm */
  @Type(() => Number)
  @IsInt()
  @IsOptional()
  category_id?: number;

  /** 🖼️ Danh sách ảnh sản phẩm */
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateProductImageDto)
  @IsOptional()
  images?: CreateProductImageDto[];

  /** ⚙️ Thông số kỹ thuật (specs: JSONB) */
  @IsOptional()
  @IsObject()
  specs?: Record<string, any>;

  /** 🌍 Xuất xứ */
  @IsOptional()
  @IsString()
  origin?: string;

  /** 📘 Hướng dẫn sử dụng (user_manual: JSONB) */
  @IsOptional()
  @ValidateNested()
  @Type(() => UserManualDto)
  user_manual?: UserManualDto;

  /** ⚠️ Ghi chú / cảnh báo an toàn */
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  caution_notes?: string[];

  /** 🔀 Danh sách biến thể sản phẩm (product_variants) */
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateProductVariantDto)
  variants?: CreateProductVariantDto[];

  @IsOptional()
  @ValidateNested()
  @Type(() => InitialReceiptDto)
  initialReceipt?: InitialReceiptDto;
}
