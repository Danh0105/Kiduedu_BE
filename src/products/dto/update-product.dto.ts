import { PartialType, OmitType } from '@nestjs/mapped-types';
import {
    IsOptional,
    IsArray,
    ValidateNested,
    IsString,
    IsBoolean,
    IsNumber,
} from 'class-validator';
import { Type } from 'class-transformer';
import { CreateProductDto } from './create-product.dto';

// === DTO ẢNH CHO UPDATE (có public_id, isPrimary linh hoạt) ===
class ProductImageForUpdateDto {
    @IsString()
    imageUrl: string;

    @IsString()
    @IsOptional()
    publicId?: string | null;

    @IsString()
    @IsOptional()
    altText?: string;

    @IsBoolean()
    @IsOptional()
    isPrimary?: boolean;


}

// === DTO BIẾN THỂ CHO UPDATE (sku bắt buộc, variantName optional) ===
export class ProductVariantForUpdateDto {
    @IsOptional()
    @IsNumber()
    variantId?: number | null;

    @IsString()
    sku: string;

    @IsOptional()
    @IsString()
    variantName?: string;

    @IsOptional()
    attributes?: Record<string, any>;

    @IsOptional()
    specs?: any[];

    // BỎ HOÀN TOÀN VALIDATION
    @IsOptional()
    imageUrl?: string;

    @IsOptional()
    @IsArray()
    prices?: Array<{
        priceType: string;
        price: number;
        currencyCode?: string;
        startAt?: string;
        endAt?: string | null;
    }>;
}

// === UPDATE DTO CHUẨN – KHÔNG GHI ĐÈ, DÙNG Omit + & ===
export class UpdateProductDto extends PartialType(
    OmitType(CreateProductDto, ['images', 'variants'] as const)
) {
    @IsOptional()
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => ProductImageForUpdateDto)
    images?: ProductImageForUpdateDto[];

    @IsOptional()
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => ProductVariantForUpdateDto)
    variants?: ProductVariantForUpdateDto[] | null;
}