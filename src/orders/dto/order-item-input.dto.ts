import { IsInt, IsNumber, IsObject, IsOptional, Min, ValidateIf } from 'class-validator';

export class OrderItemInputDto {
    @ValidateIf(o => o.variantId !== null)
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

    @IsOptional()
    @IsObject()
    attributes?: Record<string, any>;

}
