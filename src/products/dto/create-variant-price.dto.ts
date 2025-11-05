import { IsNotEmpty, IsString, IsOptional, IsNumber } from 'class-validator';

export class CreateVariantPriceDto {
  @IsString() @IsNotEmpty()
  priceType: string;

  @IsOptional()
  @IsString()
  currencyCode?: string = 'VND';

  @IsNumber()
  price: number;

  @IsOptional()
  startAt?: Date;

  @IsOptional()
  endAt?: Date;
}
