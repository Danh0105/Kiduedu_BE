import { Expose, Type } from 'class-transformer';

/* ========================================================================== */
/* 🖼️ Ảnh sản phẩm                                                            */
/* ========================================================================== */
export class ImageResponseDto {
  @Expose() imageId: number;
  @Expose() imageUrl: string;
  @Expose() altText?: string;
  @Expose() isPrimary?: boolean;
}

/* ========================================================================== */
/* 🗂️ Danh mục                                                                */
/* ========================================================================== */
export class CategoryResponseDto {
  @Expose() categoryId: number;
  @Expose() categoryName: string;
  @Expose() description?: string;
}

/* ========================================================================== */
/* ⚙️ Thông số kỹ thuật (SpecItem[])                                         */
/* ========================================================================== */
export class SpecItemDto {
  @Expose() key: string;
  @Expose() label: string;
  @Expose() value: string;
  @Expose() unit?: string | null;
  @Expose() type?: 'text' | 'number' | 'boolean';
  @Expose() group?: string | null;
  @Expose() note?: string | null;
  @Expose() order?: number;
}

/* ========================================================================== */
/* 📖 Hướng dẫn sử dụng (JSONB object)                                        */
/* ========================================================================== */
export class UserManualDto {
  @Expose() pdf?: string;
  @Expose() video?: string;
  @Expose() steps?: string[];
}

/* ========================================================================== */
/* 🧩 Option Type / Value (nếu còn dùng để trình bày)                          */
/* ========================================================================== */
export class OptionTypeDto {
  @Expose() optionTypeId: number;
  @Expose() name: string;
  @Expose() position?: number;
}

export class OptionValueDto {
  @Expose() optionValueId: number;
  @Expose() value: string;
  @Expose() position?: number;

  @Expose()
  @Type(() => OptionTypeDto)
  optionType: OptionTypeDto;
}

/* ========================================================================== */
/* 🧱 Product Variant                                                          */
/* ========================================================================== */
export class ProductVariantResponseDto {
  @Expose() variantId: number;
  @Expose() productId: number;
  @Expose() variantName: string;
  @Expose() sku?: string;
  @Expose() barcode?: string;
  @Expose() status: number;
  @Expose() imageUrl?: string;

  // Giá hiện hành (nếu đã tính ở service)
  @Expose() currentPrice?: number;

  // Thuộc tính phụ ở cấp biến thể (JSONB)
  @Expose() attributes?: Record<string, any>;

  // Kích thước/khối lượng (nếu có trong DB)
  @Expose() weightGram?: number | null;
  @Expose() lengthMm?: number | null;
  @Expose() widthMm?: number | null;
  @Expose() heightMm?: number | null;

  @Expose() createdAt: Date;
  @Expose() updatedAt: Date;

  @Expose()
  @Type(() => OptionValueDto)
  formattedOptionValues?: OptionValueDto[];

  @Expose()
  @Type(() => ImageResponseDto)
  images?: ImageResponseDto[];

  @Expose()
  @Type(() => SpecItemDto)
  specs: SpecItemDto[];
}

/* ========================================================================== */
/* 🧩 Product Response — dữ liệu trả về cho FE                                 */
/* ========================================================================== */
export class ProductResponseDto {
  @Expose() productId: number;
  @Expose() productName: string;
  @Expose() sku?: string;
  @Expose() shortDescription?: string | null;
  @Expose() longDescription?: string | null;
  @Expose() status: number;

  // Nếu còn dùng các cột price/stock ở product
  @Expose() price?: number;
  @Expose() stockQuantity?: number;

  @Expose() createdAt: Date;
  @Expose() updatedAt: Date;

  /* ===== JSONB fields ===== */


  @Expose() origin?: string | null;

  @Expose()
  @Type(() => UserManualDto)
  userManual?: UserManualDto | null;

  @Expose()
  cautionNotes?: string[] | null;       // <— mảng string, không cần class bọc

  /* ===== Relations ===== */
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
