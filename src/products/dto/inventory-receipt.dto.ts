import {
    IsString,
    IsNotEmpty,
    IsOptional,
    MaxLength,
    IsInt,
    IsPositive,
    IsNumber,
    IsDateString,
} from 'class-validator';
import { Type } from 'class-transformer';
import { PartialType } from '@nestjs/mapped-types';

export class CreateInventoryReceiptDto {
    @IsString()
    @IsNotEmpty()
    @MaxLength(50)
    receiptCode: string;

    @IsDateString()
    receiptDate: string;

    @IsInt()
    @IsPositive()
    supplierId: number;

    @IsOptional()
    @IsString()
    @MaxLength(100)
    referenceNo?: string;

    @IsOptional()
    @IsString()
    note?: string;

    @IsOptional()
    @Type(() => Number)
    @IsNumber()
    totalAmount?: number;
}

export class UpdateInventoryReceiptDto extends PartialType(
    CreateInventoryReceiptDto,
) { }
