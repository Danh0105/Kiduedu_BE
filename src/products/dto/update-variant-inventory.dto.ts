import { IsInt, Min } from 'class-validator';

export class UpdateVariantInventoryDto {
  @IsInt() @Min(0)
  stock_quantity: number;

  @IsInt() @Min(0)
  safety_stock: number;
}
