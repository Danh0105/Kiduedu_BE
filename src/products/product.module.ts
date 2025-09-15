// product.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductController } from './product.controller';
import { ProductService } from './product.service';
import { Product } from './entities/product.entity';
import { AuthModule } from '../auth/auth.module';
import { ProductAttributeValue } from './entities/product-attribute-value.entity';
import { Attribute } from './entities/attribute.entity';
import { CategoryAttribute } from './entities/category-attribute.entity';
import { Category } from '../categories/entities/category.entity';
import { ProductImage } from './entities/product-image.entity';
@Module({
  imports: [
    AuthModule,
    TypeOrmModule.forFeature([
      Product,
      ProductAttributeValue,
      Attribute,
      CategoryAttribute,
      Category,
      ProductImage,
    ]),

  ],
  controllers: [ProductController],
  providers: [ProductService],
})
export class ProductModule { }
