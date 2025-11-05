import { Expose, Type } from 'class-transformer';
import { CreateProductVariantDto } from './create-product-variant.dto';
import { ProductVariantResponseDto } from './product-variant-response.dto';

// 🖼️ DTO cho ảnh sản phẩm
export class ImageResponseDto {
  @Expose()
  imageId: number;

  @Expose()
  imageUrl: string;

  @Expose()
  altText?: string;

  @Expose()
  isPrimary?: boolean;
}

// 🗂️ DTO cho danh mục
export class CategoryResponseDto {
  @Expose()
  categoryId: number;

  @Expose()
  categoryName: string;

  @Expose()
  description?: string;
}

// ⚙️ DTO cho thông số kỹ thuật (specs)
export class SpecsDto {
  [key: string]: any;
}

// 📖 DTO cho hướng dẫn sử dụng
export class UserManualDto {
  @Expose()
  pdf?: string;

  @Expose()
  video?: string;

  @Expose()
  steps?: string[];
}

// ⚠️ Ghi chú an toàn / lưu ý sản phẩm
export class CautionNotesDto {
  @Expose()
  notes: string[];
}

// 🧩 DTO phản hồi chính cho Product
export class ProductResponseDto {
  @Expose()
  productId: number;

  @Expose()
  productName: string;

  @Expose()
  sku?: string;

  @Expose()
  shortDescription?: string;

  @Expose()
  longDescription?: string;

  @Expose()
  status: number;

  @Expose()
  price: number;

  @Expose()
  stockQuantity: number;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // ====== Các trường JSONB ======
  @Expose()
  @Type(() => SpecsDto)
  specs: Record<string, any>;

  @Expose()
  origin?: string;

  @Expose()
  @Type(() => UserManualDto)
  userManual?: UserManualDto | null;

  @Expose()
  @Type(() => CautionNotesDto)
  cautionNotes?: string[];

  // ====== Quan hệ ======
  @Expose()
  @Type(() => CategoryResponseDto)
  category?: CategoryResponseDto | null;

  @Expose()
  @Type(() => ImageResponseDto)
  images?: ImageResponseDto[];


  @Expose()
  @Type(() => ProductVariantResponseDto)
  variants?: ProductVariantResponseDto[];
}
