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
  ValidateIf,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { CustomerType } from '../entities/user.entity';
import { Column } from 'typeorm';

export enum PaymentMethod {
  MOMO = 'momo',
  COD = 'cod',
  BANK = 'vnpay',
  VIETQR = 'vietqr',
}

export enum PaymentStatus {
  PENDING = 'Pending',
  PAID = 'PAID',
  FAILED = 'FAILED',
}

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
  @ValidateIf(o => o.variantId !== null && o.variantId !== undefined)
  @IsInt()
  variantId?: number | null;


  @ValidateIf(o => o.productId !== null)
  @IsInt()
  productId?: number | null;

  @IsInt()
  @Min(1)
  quantity: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  pricePerUnit?: number;



}


export class CreateUserDto {
  @IsOptional()
  @IsInt()
  id?: number;

  @IsString()
  @IsNotEmpty()
  username?: string;

  @IsOptional()
  @IsString()
  password?: string;

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

  @IsEnum(PaymentMethod)
  paymentMethod: PaymentMethod;

  @IsOptional()
  @IsEnum(PaymentStatus)
  paymentStatus?: PaymentStatus;
}
