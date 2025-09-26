// src/users/dto/create-user.dto.ts
import { IsEmail, IsNotEmpty, IsOptional, IsEnum, ValidateNested, IsArray } from 'class-validator';
import { Type } from 'class-transformer';
import { CustomerType } from '../entities/user.entity';

class AddressDto {
  @IsNotEmpty()
  full_name: string;

  @IsNotEmpty()
  phone_number: string;

  @IsNotEmpty()
  street: string;

  @IsNotEmpty()
  ward: string;

  @IsNotEmpty()
  district: string;

  @IsNotEmpty()
  city: string;

  @IsOptional()
  is_default?: boolean;
}

export class CreateUserDto {
  @IsNotEmpty()
  username: string;

  @IsEmail()
  email: string;

  @IsNotEmpty()
  password: string;

  @IsOptional()
  fullName?: string;

  @IsOptional()
  role?: string;

  @IsEnum(CustomerType)
  customerType: CustomerType;

  // Thông tin doanh nghiệp (nếu có)
  @IsOptional()
  companyName?: string;

  @IsOptional()
  taxId?: string;

  @IsOptional()
  businessEmail?: string;

  // Địa chỉ mặc định
  @ValidateNested()
  @Type(() => AddressDto)
  address: AddressDto;

  @IsArray()
  items: { product_id: number; quantity: number; price_per_unit: number }[];
}
