// src/modules/products/controllers/product-rentals.controller.ts
import {
    Body,
    Controller,
    Get,
    Param,
    ParseIntPipe,
    Post,
    Req,
} from '@nestjs/common';
import { ProductRentalsService } from '../services/product-rentals.service';
import { CreateRentalDto } from '../dto/create-rental.dto';

@Controller('products/:productId/variants/:variantId/rentals')
export class ProductRentalsController {
    constructor(private readonly service: ProductRentalsService) { }

    @Get('prices')
    getRentalPrices(@Param('variantId', ParseIntPipe) variantId: number) {
        return this.service.getRentalPrices(variantId);
    }

    @Get()
    listRentals(@Param('variantId', ParseIntPipe) variantId: number) {
        return this.service.listRentals(variantId);
    }

    @Post()
    createRental(
        @Req() req: any, // JWT chứa user
        @Param('variantId', ParseIntPipe) variantId: number,
        @Body() dto: CreateRentalDto,
    ) {
        const userId = req.user?.id || 1; // demo
        return this.service.createRental(userId, { ...dto, variantId });
    }
}
