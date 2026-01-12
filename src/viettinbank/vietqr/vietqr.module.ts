import { Module } from '@nestjs/common';
import { VietQrService } from './vietqr.service';
import { VietQrController } from './vietqr.controller';

@Module({
    controllers: [VietQrController],
    providers: [VietQrService],
    exports: [VietQrService],
})
export class VietQrModule { }
