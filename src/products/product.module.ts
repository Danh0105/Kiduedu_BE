// product.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { ProductController } from './controllers/product.controller';
import { ProductService } from './services/product.service';

import { InventoryController } from './controllers/inventory.controller';
import { InventoryService } from './services/inventory.service';

import { SupplierController } from './controllers/supplier.controller';
import { SupplierService } from './services/supplier.service';

import { Product } from './entities/product.entity';
import { Attribute } from './entities/attribute.entity';
import { CategoryAttribute } from './entities/category-attribute.entity';
import { Category } from '../categories/entities/category.entity';
import { ProductImage } from './entities/product-image.entity';
import { ProductVariant } from './entities/product-variant.entity';
import { ProductVariantPrice } from './entities/product-variant-price.entity';
import { ProductVariantInventory } from './entities/product-variant-inventory.entity';
import { InventoryReceipt } from './entities/inventory-receipt.entity';
import { InventoryReceiptItem } from './entities/inventory-receipt-item.entity';
import { Supplier } from './entities/supplier.entity';

import { UploadService } from 'src/upload/upload.service';
import { ProductVariantRental } from './entities/product-variant-rental.entity';
import { ProductVariantRentalPrice } from './entities/product-variant-rental-price.entity';


@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      Attribute,
      CategoryAttribute,
      Category,
      ProductImage,
      ProductVariant,
      ProductVariantPrice,
      ProductVariantInventory,
      InventoryReceipt,
      InventoryReceiptItem,
      Supplier,
      ProductVariantRental,
      ProductVariantRentalPrice,
    ]),
  ],
  controllers: [
    ProductController,
    InventoryController,
    SupplierController,
  ],
  providers: [
    ProductService,
    InventoryService,
    SupplierService,
    UploadService,
  ],
  exports: [
    ProductService,
    InventoryService,
  ],
})
export class ProductModule { }
