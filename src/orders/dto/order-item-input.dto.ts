// src/orders/dto/order-item-input.dto.ts
import {
    IsInt,
    IsNumber,
    Min,
    IsOptional,
    IsObject,
} from 'class-validator';

export class OrderItemInputDto {
    @IsInt()
    @Min(1)
    variantId: number;

    @IsInt()
    @Min(1)
    quantity: number;

    // Nếu bạn không muốn client gửi giá, có thể bỏ field này
    @IsNumber()
    @Min(0)
    pricePerUnit: number;

    @IsOptional()
    @IsObject()
    attributes?: Record<string, any>;
}
