import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import 'dotenv/config';
import "reflect-metadata";

import * as fs from 'fs';

async function bootstrap() {
  const httpsOptions = {
    key: fs.readFileSync('./secrets/key.pem'),
    cert: fs.readFileSync('./secrets/cert.pem'),
  };

  const app = await NestFactory.create(AppModule, { httpsOptions });

  app.enableCors({
    origin: 'https://kidoedu.vn',
    credentials: true,
  });

  await app.listen(443, '0.0.0.0'); // HTTPS mặc định chạy port 443
}
bootstrap();