import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import 'dotenv/config';
import "reflect-metadata";


async function bootstrap() {

  const app = await NestFactory.create(AppModule);
  const whitelist = [
    'https://www.kidoedu.edu.vn',
    'https://kidoedu.vn',
    'http://localhost:3001',   // nếu cần dev
  ];

  app.enableCors({
    origin: (origin, cb) => {
      // Cho phép non-browser (Postman) origin null
      if (!origin) return cb(null, true);
      cb(null, whitelist.includes(origin));
    },
    credentials: true, // 👈 bật
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Origin', 'X-Requested-With', 'Content-Type', 'Accept', 'Authorization'],
    exposedHeaders: ['Content-Disposition'], // nếu cần tải file
  });

  await app.listen(3000, '0.0.0.0');


}
bootstrap();