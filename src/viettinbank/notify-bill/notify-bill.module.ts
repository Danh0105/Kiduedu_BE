import { Module } from "@nestjs/common";
import { NotifyBillController } from "./notify-bill.controller";
import { NotifyBillService } from "./notify-bill.service";
import { CryptoKeyService } from '../crypto/crypto-key.service';
import { TypeOrmModule } from "@nestjs/typeorm";
import { Order } from "src/orders/entities/order.entity";
@Module({
    imports: [
        TypeOrmModule.forFeature([Order]),
    ],
    controllers: [NotifyBillController],
    providers: [NotifyBillService, CryptoKeyService],
})
export class NotifyBillModule { }
