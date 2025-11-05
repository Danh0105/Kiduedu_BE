import { IsInt, IsNotEmpty, IsObject, IsOptional, IsString, MaxLength } from 'class-validator';

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
}
