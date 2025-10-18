import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PaymentPolicy } from './entities/payment-policy.entity';
import { PaymentPolicyService } from './payment-policy.service';
import { PaymentPolicyController } from './payment-policy.controller';

@Module({
    imports: [TypeOrmModule.forFeature([PaymentPolicy])],
    controllers: [PaymentPolicyController],
    providers: [PaymentPolicyService],
    exports: [TypeOrmModule],
})
export class PaymentPolicyModule { }
