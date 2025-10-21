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
    ]),

  ],
  controllers: [ProductController, ProductVariantsController],
  providers: [ProductService, ProductVariantsService],
  exports: [ProductVariantsService],
})
export class ProductModule { }
