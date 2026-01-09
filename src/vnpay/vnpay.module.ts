// src/vnpay/vnpay.module.ts
import { MiddlewareConsumer, Module, RequestMethod } from '@nestjs/common';
import { VnpayController } from './vnpay.controller';
import { VnpayService } from './vnpay.service';
import { ConfigModule } from '@nestjs/config';
import { Order } from 'src/orders/entities/order.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { VnpayIpnWhitelistMiddleware } from './middleware/vnpay-ipn-whitelist.middleware';

@Module({
    imports: [
        ConfigModule,
        TypeOrmModule.forFeature([Order]),
    ],
    controllers: [VnpayController],
    providers: [VnpayService],
    exports: [VnpayService],
})

export class VnpayModule {

    configure(consumer: MiddlewareConsumer) {
        consumer
            .apply(VnpayIpnWhitelistMiddleware)
            .forRoutes({
                path: 'vnpay/ipn',
                method: RequestMethod.GET,
            });
    }
}
