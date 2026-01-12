import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SpinsController } from './spins.controller';
import { SpinsService } from './spins.service';
import { User } from '../users-prizes/user.entity';
import { Prize } from '../prizes/prize.entity';
import { SpinLog } from './spin-log.entity';

@Module({
    imports: [
        TypeOrmModule.forFeature([User, Prize, SpinLog]),
    ],
    controllers: [SpinsController],
    providers: [SpinsService],
})
export class SpinsModule { }
