// src/modules/rental-orders/dto/create-rental-order-item.dto.ts
import {
    IsInt, IsOptional, IsPositive, IsNumber, Min, IsDateString, IsEnum,
} from 'class-validator';
import { RentalType, ReturnStatus } from '../enums/rental-order-item.enums';

export class CreateRentalOrderItemDto {
    @IsInt()
    rentalOrderId!: number;

    @IsInt()
    variantId!: number;

    @IsOptional()
    @IsEnum(RentalType)
    rentalType?: RentalType;

    @IsNumber()
    @Min(0)
    price!: number;

    @IsNumber()
    @Min(0)
    deposit!: number;

    @IsInt()
    @IsPositive()
    quantity!: number;

    @IsOptional() @IsDateString() startDate?: string;
    @IsOptional() @IsDateString() endDate?: string;
    @IsOptional() @IsDateString() returnedAt?: string;

    @IsOptional()
    @IsEnum(ReturnStatus)
    returnStatus?: ReturnStatus;
}
