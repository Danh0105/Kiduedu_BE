import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Order } from './entities/order.entity';
import { OrderItem } from './entities/order-item.entity';
import { OrdersService } from './orders.service';
import { OrdersController } from './orders.controller';
import { InventoryReceipt } from 'src/products/entities/inventory-receipt.entity';
import { InventoryReceiptItem } from 'src/products/entities/inventory-receipt-item.entity';
import { ProductVariantInventory } from 'src/products/entities/product-variant-inventory.entity';
import { ProductModule } from 'src/products/product.module';

@Module({
  imports: [TypeOrmModule.forFeature([
    Order,
    OrderItem,
    InventoryReceipt,
    InventoryReceiptItem,
    ProductVariantInventory,

  ]),
    ProductModule,
  ],

  controllers: [OrdersController],
  providers: [OrdersService],
  exports: [OrdersService],
})
export class OrdersModule { }
