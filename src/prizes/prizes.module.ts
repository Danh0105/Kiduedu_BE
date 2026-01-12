import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Prize } from './prize.entity';
import { PrizesController } from './prizes.controller';
import { PrizesService } from './prizes.service';

@Module({
    imports: [TypeOrmModule.forFeature([Prize])],
    controllers: [PrizesController],
    providers: [PrizesService],
    exports: [TypeOrmModule],
})
export class PrizesModule { }
