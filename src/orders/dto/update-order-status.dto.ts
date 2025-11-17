// src/orders/dto/update-order-status.dto.ts
import { IsString } from 'class-validator';

export class UpdateOrderStatusDto {
    @IsString()
    status: string;
}
