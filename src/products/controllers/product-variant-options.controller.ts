import {
    Body, Controller, Delete, Get, Param, ParseIntPipe, Post
} from '@nestjs/common';
import { ProductVariantOptionsService } from '../services/product-variant-options.service';
import { AddVariantOptionDto } from '../dto/add-variant-option.dto';

@Controller('products/:productId/variants/:variantId/options')
export class ProductVariantOptionsController {
    constructor(private readonly service: ProductVariantOptionsService) { }

    @Get()
    listOptions(
        @Param('variantId', ParseIntPipe) variantId: number
    ) {
        return this.service.listOptions(variantId);
    }


    @Post()
    addOption(
        @Param('variantId', ParseIntPipe) variantId: number,
        @Body() dto: AddVariantOptionDto
    ) {
        return this.service.addOption(variantId, dto);
    }

    @Delete(':optionValueId')
    removeOption(
        @Param('variantId', ParseIntPipe) variantId: number,
        @Param('optionValueId', ParseIntPipe) optionValueId: number
    ) {
        return this.service.removeOption(variantId, optionValueId);
    }
}
