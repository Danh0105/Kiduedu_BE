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
    ]),

  ],
  controllers: [ProductController, ProductVariantsController, ProductVariantPricesController],
  providers: [ProductService, ProductVariantsService, ProductVariantPricesService],
  exports: [ProductVariantsService, ProductVariantPricesService],
})
export class ProductModule { }
