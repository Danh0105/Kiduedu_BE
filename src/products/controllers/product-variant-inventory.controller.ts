import {
    Body, Controller, Get, Param, ParseIntPipe, Patch
} from '@nestjs/common';
import { ProductVariantInventoryService } from '../services/product-variant-inventory.service';
import { UpdateVariantInventoryDto } from '../dto/update-variant-inventory.dto';

@Controller('products/:productId/variants/:variantId/inventory')
export class ProductVariantInventoryController {
    constructor(private readonly service: ProductVariantInventoryService) { }

    @Get()
    getInventory(
        @Param('variantId', ParseIntPipe) variantId: number
    ) {
        return this.service.getInventory(variantId);
    }

    @Patch()
    updateInventory(
        @Param('variantId', ParseIntPipe) variantId: number,
        @Body() dto: UpdateVariantInventoryDto
    ) {
        return this.service.updateInventory(variantId, dto);
    }
}
