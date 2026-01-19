// src/inq-bill/inq-bill.module.ts
import { Module } from '@nestjs/common';
import { InqBillController } from './inq-bill.controller';
import { InqBillService } from './inq-bill.service';
import { CryptoKeyService } from '../crypto/crypto-key.service';
import { OrdersService } from 'src/orders/orders.service';
import { Order } from 'src/orders/entities/order.entity';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
    imports: [
        TypeOrmModule.forFeature([Order]),
    ],
    controllers: [InqBillController],
    providers: [
        InqBillService,
        CryptoKeyService,
    ],
    exports: [InqBillService],
})
export class InqBillModule { }
