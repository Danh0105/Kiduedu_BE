import {
    Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post
} from '@nestjs/common';
import { ProductVariantPricesService } from '../services/product-variant-prices.service';
import { CreateVariantPriceDto } from '../dto/create-variant-price.dto';
import { UpdateVariantPriceDto } from '../dto/update-variant-price.dto';

@Controller('products/:productId/variants/:variantId/prices')
export class ProductVariantPricesController {
    constructor(private readonly service: ProductVariantPricesService) { }

    @Get()
    findAll(
        @Param('variantId', ParseIntPipe) variantId: number
    ) {
        return this.service.findAll(variantId);
    }

    @Get(':priceId')
    findOne(
        @Param('variantId', ParseIntPipe) variantId: number,
        @Param('priceId', ParseIntPipe) priceId: number
    ) {
        return this.service.findOne(variantId, priceId);
    }

    @Post()
    create(
        @Param('variantId', ParseIntPipe) variantId: number,
        @Body() dto: CreateVariantPriceDto
    ) {
        return this.service.create(variantId, dto);
    }

    @Patch(':priceId')
    update(
        @Param('variantId', ParseIntPipe) variantId: number,
        @Param('priceId', ParseIntPipe) priceId: number,
        @Body() dto: UpdateVariantPriceDto
    ) {
        return this.service.update(variantId, priceId, dto);
    }

    @Delete(':priceId')
    remove(
        @Param('variantId', ParseIntPipe) variantId: number,
        @Param('priceId', ParseIntPipe) priceId: number
    ) {
        return this.service.remove(variantId, priceId);
    }
}
