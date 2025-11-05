// src/modules/products/dto/create-rental.dto.ts
import { IsDateString, IsEnum, IsInt, IsNotEmpty, IsNumber, Min } from 'class-validator';

export class CreateRentalDto {
    @IsInt()
    @IsNotEmpty()
    variantId: number;

    @IsEnum(['daily', 'weekly', 'monthly'])
    rentalType: 'daily' | 'weekly' | 'monthly';

    @IsDateString()
    startDate: string;

    @IsDateString()
    endDate: string;

    @IsNumber()
    @Min(0)
    depositPaid: number;
}
