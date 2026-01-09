import { Module } from "@nestjs/common";
import { NotifyBillController } from "./notify-bill.controller";
import { NotifyBillService } from "./notify-bill.service";
import { CryptoKeyService } from '../crypto/crypto-key.service';
@Module({
    controllers: [NotifyBillController],
    providers: [NotifyBillService, CryptoKeyService],
})
export class NotifyBillModule { }
