// src/orders/dto/create-order.dto.ts
import {
    IsInt,
    IsOptional,
    IsString,
    IsArray,
    ValidateNested,
    Min,
} from 'class-validator';
import { Type } from 'class-transformer';
import { OrderItemInputDto } from './order-item-input.dto';

export class CreateOrderDto {
    @IsInt()
    @Min(1)
    userId: number;

    @IsString()
    shippingAddress: string;

    @IsOptional()
    @IsInt()
    promotionId?: number;

    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => OrderItemInputDto)
    items: OrderItemInputDto[];
}
