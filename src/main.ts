import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import 'dotenv/config';
import "reflect-metadata";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors({
    origin: 'https://kidu-kq2b3mm22-danh0105s-projects.vercel.app',
    credentials: true,
  });
  await app.listen(3000, '0.0.0.0');

}
bootstrap();