// src/data-source.ts
import 'dotenv/config';
import { DataSource } from 'typeorm';
import path from 'path';

const isProd = process.env.NODE_ENV === 'production';

// Globs cho DEV (ts) và PROD (js)
const entities = isProd
  ? [path.resolve(__dirname, '**/*.entity.js')]
  : [path.resolve(__dirname, '**/*.entity.ts')];

const migrations = isProd
  ? [path.resolve(__dirname, 'migrations/*.js')]
  : [path.resolve(__dirname, 'migrations/*.ts')];

export default new DataSource({
  type: 'postgres',
  host: process.env.POSTGRES_HOST ?? '127.0.0.1',
  port: Number(process.env.POSTGRES_PORT ?? 5432),
  username: process.env.POSTGRES_USER ?? 'postgres',
  password: process.env.POSTGRES_PASSWORD ?? 'postgres',
  database: process.env.POSTGRES_DB ?? 'postgres',

  // Dùng migration → để false trong prod
  synchronize: false,
  dropSchema: false,
  // Bật log khi dev, prod chỉ error (giảm noise)
  logging: isProd ? ['error'] : ['error', 'warn'],

  entities,
  migrations,

  // Tùy chọn ổn định kết nối (node-postgres)
  extra: {
    application_name: 'nestjs-app',
    keepAlive: true,
    connectionTimeoutMillis: 10000,
    idleTimeoutMillis: 30000,
    max: 10,
  },

  // Nếu Postgres local không bật SSL
  ssl: false,
});
