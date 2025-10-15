import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Banner } from './entities/banner.entity';


@Module({
  imports: [TypeOrmModule.forFeature([Banner])],
})
export class BannerModule { }
