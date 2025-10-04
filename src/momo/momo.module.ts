import { Module } from '@nestjs/common';
import { MomoService } from './momo.service';
import { MomoController } from './momo.controller';

@Module({
  imports: [], // nếu dùng ConfigService thì import ConfigModule ở đây
  controllers: [MomoController],
  providers: [MomoService],
  exports: [MomoService], // nếu muốn dùng ở module khác
})
export class MomoModule { }
