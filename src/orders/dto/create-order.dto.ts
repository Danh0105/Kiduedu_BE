// src/orders/dto/create-order.dto.ts
import {
    IsInt,
    IsOptional,
    IsString,
    IsArray,
    ValidateNested,
    Min,
    IsEnum,
} from 'class-validator';
import { Type } from 'class-transformer';
import { OrderItemInputDto } from './order-item-input.dto';

/**
 * Các phương thức thanh toán cho phép
 * (Không cho client gửi linh tinh)
 */
export enum CreateOrderPaymentMethod {
    COD = 'cod',
    MOMO = 'momo',
    VNPAY = 'vnpay',
}

export class CreateOrderDto {
    /* ================= USER ================= */

    @IsOptional()
    @IsInt()
    @Min(1)
    userId?: number;

    /* ================= SHIPPING ================= */

    @IsString()
    shippingAddress: string;

    /* ================= PROMOTION ================= */

    @IsOptional()
    @IsInt()
    promotionId?: number;

    /* ================= PAYMENT ================= */

    @IsEnum(CreateOrderPaymentMethod)
    paymentMethod: CreateOrderPaymentMethod;

    /* ================= ITEMS ================= */

    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => OrderItemInputDto)
    items: OrderItemInputDto[];
}
