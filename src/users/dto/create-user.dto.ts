import {
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsEnum,
  IsArray,
  ValidateNested,
  IsNumber,
  IsObject,
  Min,
  IsInt,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { CustomerType } from '../entities/user.entity';
import { Column } from 'typeorm';

export class AddressDto {
  @IsString()
  full_name: string;

  @IsString()
  phone_number: string;

  @IsString()
  street: string;

  @IsString()
  ward: string;

  @IsString()
  district: string;

  @IsString()
  city: string;

  @IsOptional()
  is_default?: boolean;
}
export class OrderItemInputDto {
  @IsInt() variantId: number;
  @IsInt() @Min(1) quantity: number;

  // order-item.entity.ts
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  pricePerUnit: number;

  @IsOptional() @IsObject()
  attributes?: Record<string, any>;
}


export class CreateUserDto {
  @IsString()
  @IsNotEmpty()
  username: string;

  @IsEmail()
  email: string;

  @IsOptional()
  @IsString()
  role?: string;

  @IsOptional()
  @IsEnum(CustomerType)
  customerType?: CustomerType;

  @IsOptional()
  @IsString()
  companyName?: string;

  @IsOptional()
  @IsString()
  taxId?: string;

  @IsOptional()
  @IsString()
  businessEmail?: string;

  @IsOptional()
  @IsString()
  fullName?: string;

  @IsOptional()
  @IsString()
  dateOfBirth?: string;

  @IsOptional()
  @ValidateNested()
  @Type(() => AddressDto)
  address?: AddressDto;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => OrderItemInputDto)
  items: OrderItemInputDto[];
}
