import {
    IsInt,
    IsPositive,
    IsNumber,
} from 'class-validator';
import { Type } from 'class-transformer';
import { PartialType } from '@nestjs/mapped-types';

export class CreateInventoryReceiptItemDto {
    @IsInt()
    @IsPositive()
    receiptId: number;

    @IsInt()
    @IsPositive()
    variantId: number;

    @IsInt()
    @IsPositive()
    quantity: number;

    @Type(() => Number)
    @IsNumber()
    @IsPositive()
    unitCost: number;

    @Type(() => Number)
    @IsNumber()
    @IsPositive()
    lineTotal: number; // hoặc để optional nếu bạn tính trên server
}

export class UpdateInventoryReceiptItemDto extends PartialType(
    CreateInventoryReceiptItemDto,
) { }
