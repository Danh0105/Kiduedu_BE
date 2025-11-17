import {
    IsString,
    IsNotEmpty,
    IsOptional,
    MaxLength,
    IsEmail,
} from 'class-validator';
import { PartialType } from '@nestjs/mapped-types';

export class CreateSupplierDto {
    @IsString()
    @IsNotEmpty()
    @MaxLength(255)
    supplierName: string;

    @IsOptional()
    @IsString()
    @MaxLength(20)
    phone?: string;

    @IsOptional()
    @IsEmail()
    @MaxLength(255)
    email?: string;

    @IsOptional()
    @IsString()
    address?: string;

    @IsOptional()
    @IsString()
    note?: string;
}

export class UpdateSupplierDto extends PartialType(CreateSupplierDto) { }
