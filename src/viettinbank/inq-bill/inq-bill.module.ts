// src/inq-bill/inq-bill.module.ts
import { Module } from '@nestjs/common';
import { InqBillController } from './inq-bill.controller';
import { InqBillService } from './inq-bill.service';
import { CryptoKeyService } from '../crypto/crypto-key.service';

@Module({
    controllers: [InqBillController],
    providers: [
        InqBillService,
        CryptoKeyService,
    ],
    exports: [InqBillService],
})
export class InqBillModule { }
