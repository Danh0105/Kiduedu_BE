// src/modules/rental-orders/dto/create-rental-order.dto.ts
import { IsInt, IsNumber, Min, IsOptional, IsString, MaxLength, IsEnum } from 'class-validator';
import { RentalOrderStatus } from '../enums/rental-order.enums';

export class CreateRentalOrderDto {
    @IsInt()
    userId!: number;

    @IsNumber() @Min(0)
    totalPrice!: number;

    @IsNumber() @Min(0)
    totalDeposit!: number;

    @IsOptional()
    @IsEnum(RentalOrderStatus)
    status?: RentalOrderStatus;

    @IsOptional()
    @IsString()
    @MaxLength(10000)
    note?: string;
}
