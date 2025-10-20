import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CustomerServiceEntity } from './customer-service.entity';
import { CustomerServiceService } from './customer-service.service';
import { CustomerServiceController } from './customer-service.controller';

@Module({
    imports: [TypeOrmModule.forFeature([CustomerServiceEntity])],
    providers: [CustomerServiceService],
    controllers: [CustomerServiceController],
})
export class CustomerServiceModule { }
