// src/modules/rental-orders/dto/update-rental-order.dto.ts
import { PartialType } from '@nestjs/mapped-types';
import { CreateRentalOrderDto } from './create-rental-order.dto';

export class UpdateRentalOrderDto extends PartialType(CreateRentalOrderDto) { }
