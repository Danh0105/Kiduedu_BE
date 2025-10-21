import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import 'dotenv/config';
import "reflect-metadata";
// 👇 Hotfix: gắn crypto của Node vào global để @nestjs/typeorm khỏi lỗi
import * as nodeCrypto from 'crypto';
(global as any).crypto = nodeCrypto;


async function bootstrap() {

  const app = await NestFactory.create(AppModule);
  app.enableCors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Origin', 'X-Requested-With', 'Content-Type', 'Accept', 'Authorization'],
    credentials: false,
  });

  await app.listen(3000, '0.0.0.0');


}
bootstrap();