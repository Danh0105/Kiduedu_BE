import { IsInt, IsNumber, IsString, Min } from 'class-validator';

export class GenerateVietQrDto {
    @IsInt()
    orderId: number;

    @IsNumber()
    @Min(1)
    amount: number;

    @IsString()
    purpose: string;
}
