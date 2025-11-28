import {
  IsNotEmpty,
  IsOptional,
  IsString,
  IsInt,
  IsArray,
  ValidateNested,
  IsObject,
  IsNumber,
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
  productName: string;

  /** ✏️ Mô tả ngắn */
  @IsString()
  @IsOptional()
  shortDescription?: string;

  /** 📄 Mô tả chi tiết */
  @IsString()
  @IsOptional()
  longDescription?: string;

  /** ⚙️ Trạng thái (1=active, 0=inactive) */
  @Type(() => Number)
  @IsInt()
  @IsOptional()
  status?: number = 1;

  /** 🗂️ Danh mục sản phẩm */
  @Type(() => Number)
  @IsInt()
  @IsOptional()
  categoryId?: number;

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

  /** 📘 Hướng dẫn sử dụng */
  @IsOptional()
  @ValidateNested()
  @Type(() => UserManualDto)
  userManual?: UserManualDto;

  /** ⚠️ Ghi chú / cảnh báo an toàn */
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  cautionNotes?: string[];

  /** 🔀 Danh sách biến thể sản phẩm */
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateProductVariantDto)
  variants?: CreateProductVariantDto[] | null;

  @IsOptional()
  @ValidateNested()
  @Type(() => InitialReceiptDto)
  initialReceipt?: InitialReceiptDto | null;

  @IsNumber()
  price: number | null;


}
