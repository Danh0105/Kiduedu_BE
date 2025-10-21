import {
    Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post, Query
} from '@nestjs/common';
import { ProductVariantsService } from '../services/product-variants.service';
import { CreateProductVariantDto } from '../dto/create-product-variant.dto';
import { UpdateProductVariantDto } from '../dto/update-product-variant.dto';
import { ListVariantsQuery } from '../dto/list-variants.query';

@Controller('products/:productId/variants')
export class ProductVariantsController {
    constructor(private readonly service: ProductVariantsService) { }

    @Get()
    list(
        @Param('productId', ParseIntPipe) productId: number,
        @Query() q: ListVariantsQuery,
    ) {
        return this.service.list(productId, q);
    }

    @Get(':variantId')
    findOne(
        @Param('productId', ParseIntPipe) productId: number,
        @Param('variantId', ParseIntPipe) variantId: number,
    ) {
        return this.service.findOne(productId, variantId);
    }

    @Post()
    create(
        @Param('productId', ParseIntPipe) productId: number,
        @Body() dto: CreateProductVariantDto,
    ) {
        return this.service.create(productId, dto);
    }

    @Patch(':variantId')
    update(
        @Param('productId', ParseIntPipe) productId: number,
        @Param('variantId', ParseIntPipe) variantId: number,
        @Body() dto: UpdateProductVariantDto,
    ) {
        return this.service.update(productId, variantId, dto);
    }

    @Delete(':variantId')
    remove(
        @Param('productId', ParseIntPipe) productId: number,
        @Param('variantId', ParseIntPipe) variantId: number,
    ) {
        return this.service.remove(productId, variantId);
    }
}
