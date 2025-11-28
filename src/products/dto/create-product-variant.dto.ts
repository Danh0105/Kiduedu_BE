// src/products/dto/create-product-variant.dto.ts
import {
    IsInt,
    IsNotEmpty,
    IsObject,
    IsOptional,
    IsString,
    MaxLength,
    IsArray,
    ValidateNested,
    IsIn,
} from 'class-validator';
import { Type } from 'class-transformer';
import { CreateVariantPriceDto } from './create-variant-price.dto';

export class CreateProductVariantDto {
    @IsNotEmpty()
    @IsString()
    @MaxLength(255)
    variantName: string;

    @IsOptional()
    @IsString()
    @MaxLength(50)
    sku?: string;

    @IsOptional()
    @IsString()
    @MaxLength(64)
    barcode?: string;

    @IsOptional()
    @IsObject()
    attributes?: Record<string, any>;

    @IsOptional()
    @IsInt()
    status?: number; // default 1

    @IsOptional()
    @IsString()
    imageUrl?: string;

    /** 💰 Danh sách giá của biến thể */
    @IsOptional()
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => CreateVariantPriceDto)
    prices?: CreateVariantPriceDto[];
    @IsOptional()
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => SpecItemInputDto)
    specs?: SpecItemInputDto[];
}
export class SpecItemInputDto {
    @IsString()
    key: string;

    @IsString()
    label: string;

    @IsString()
    value: string;

    @IsOptional()
    @IsString()
    unit?: string | null;

    @IsOptional()
    @IsIn(['text', 'number', 'boolean'])
    type?: 'text' | 'number' | 'boolean';

    @IsOptional()
    @IsString()
    group?: string | null;

    @IsOptional()
    @IsString()
    note?: string | null;
}