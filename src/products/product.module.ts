// product.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductController } from './controllers/product.controller';
import { ProductService } from './services/product.service';
import { Product } from './entities/product.entity';
import { AuthModule } from '../auth/auth.module';
import { Attribute } from './entities/attribute.entity';
import { CategoryAttribute } from './entities/category-attribute.entity';
import { Category } from '../categories/entities/category.entity';
import { ProductImage } from './entities/product-image.entity';
import { ProductVariantsService } from './services/product-variants.service';
import { ProductVariantsController } from './controllers/product-variants.controller';
import { ProductVariant } from './entities/product-variant.entity';
import { ProductVariantPrice } from './entities/product-variant-price.entity';
import { ProductVariantInventory } from './entities/product-variant-inventory.entity';
import { ProductVariantRentalPrice } from './entities/product-variant-rental-price.entity';
import { ProductVariantRental } from './entities/product-variant-rental.entity';
import { ProductVariantOptionValue } from './entities/product-variant-option-value.entity';
import { OptionValue } from './entities/option-value.entity';
import { ProductVariantPricesController } from './controllers/product-variant-prices.controller';
import { ProductVariantPricesService } from './services/product-variant-prices.service';
import { ProductRentalsController } from './controllers/product-rentals.controller';
import { ProductRentalsService } from './services/product-rentals.service';
import { RentalOrder } from './entities/rental-order.entity';
import { RentalOrderItem } from './entities/rental-order-item.entity';
import { RentalOrdersController } from './controllers/rental-orders.controller';
import { RentalOrdersService } from './services/rental-orders.service';
import { OptionType } from './entities/option-type.entity';
import { ProductVariantOptionsController } from './controllers/product-variant-options.controller';
import { ProductVariantOptionsService } from './services/product-variant-options.service';
import { InventoryReceipt } from './entities/inventory-receipt.entity';
import { InventoryReceiptItem } from './entities/inventory-receipt-item.entity';
import { Supplier } from './entities/supplier.entity';
@Module({
  imports: [
    AuthModule,
    TypeOrmModule.forFeature([
      Product,
      Attribute,
      CategoryAttribute,
      Category,
      ProductImage,
      ProductVariant,
      ProductVariantPrice,
      ProductVariantInventory,
      ProductVariantRentalPrice,
      ProductVariantRental,
      ProductVariantOptionValue,
      OptionValue,
      RentalOrder,
      RentalOrderItem,
      OptionType,
      InventoryReceipt,
      InventoryReceiptItem,
      Supplier,
    ]),

  ],
  controllers: [ProductController, ProductVariantsController, ProductVariantPricesController, ProductVariantOptionsController, ProductRentalsController, RentalOrdersController],
  providers: [ProductService, ProductVariantsService, ProductVariantOptionsService, ProductVariantPricesService, ProductRentalsService, RentalOrdersService],
  exports: [ProductVariantsService, ProductVariantPricesService, ProductVariantOptionsService],
})
export class ProductModule { }
