import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import 'dotenv/config';
import "reflect-metadata";


async function bootstrap() {

  const app = await NestFactory.create(AppModule);

  // app.enableCors({
  //   origin: ['https://kidoedu.vn', 'http://localhost:3000'],
  //   methods: 'GET,POST,PUT,DELETE,OPTIONS',
  //   allowedHeaders: 'Origin,X-Requested-With,Content-Type,Accept,Authorization',
  //   credentials: true,
  // });
  await app.listen(3000);

}
bootstrap();