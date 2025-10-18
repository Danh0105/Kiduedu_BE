import { IsNotEmpty, IsString, MaxLength, IsOptional } from 'class-validator';

export class CreatePaymentPolicyDto {
    @IsString()
    @IsNotEmpty()
    @MaxLength(255)
    name: string;

    @IsOptional()
    @IsString()
    @MaxLength(255)
    description?: string;
}
