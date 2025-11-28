// src/products/dto/initial-receipt.dto.ts
import { Type } from 'class-transformer';
import {
    IsInt,
    IsNumber,
    IsOptional,
    IsPositive,
    IsString,
    ValidateNested,
    IsArray,
} from 'class-validator';

export class InitialReceiptItemDto {
    @IsOptional()
    @IsInt()
    variantId?: number;

    @IsNumber()
    @IsPositive()
    quantity: number;

    @IsNumber()
    @IsPositive()
    unitCost: number;
}

export class InitialReceiptDto {
    @IsOptional()
    @IsInt()
    supplierId?: number;

    @IsOptional()
    @IsString()
    supplierName?: string;

    @IsOptional()
    @IsString()
    supplierPhone?: string;

    @IsOptional()
    @IsString()
    supplierEmail?: string;

    @IsOptional()
    @IsString()
    supplierAddress?: string;

    @IsOptional()
    @IsString()
    supplierNote?: string;

    @IsNumber()
    @IsOptional()
    totalAmount?: number;

    @IsOptional()
    @IsString()
    receiptCode?: string;

    @IsOptional()
    @IsString()
    receiptDate?: string; // 'YYYY-MM-DD'

    @IsOptional()
    @IsString()
    referenceNo?: string;

    @IsOptional()
    @IsString()
    note?: string;

    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => InitialReceiptItemDto)
    items: InitialReceiptItemDto[];
}
