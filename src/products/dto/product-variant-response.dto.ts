import { Expose, Type } from 'class-transformer';
import { ImageResponseDto } from './ProductResponse.dto';

export class ProductVariantResponseDto {
    @Expose()
    variantId: number;

    @Expose()
    variantName: string;

    @Expose()
    sku?: string;

    @Expose()
    barcode?: string;

    @Expose()
    attributes?: Record<string, any>;

    @Expose()
    status: number;

    @Expose()
    imageUrl?: string; // ảnh đại diện (nếu có)

    @Expose()
    price?: number; // giá hiện tại (nếu muốn gộp)

    @Expose()
    stockQuantity?: number;

    @Expose()
    @Type(() => ImageResponseDto)
    images?: ImageResponseDto[];

    @Expose()
    createdAt: Date;

    @Expose()
    updatedAt: Date;
}
