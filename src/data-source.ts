// src/data-source.ts
import 'dotenv/config';
import { DataSource } from 'typeorm';
import type { DataSourceOptions } from 'typeorm';
import path from 'path';

const ROOT = process.cwd();
const SRC = path.join(ROOT, 'src');
const DIST = path.join(ROOT, 'dist');

const env = (k: string, d?: string) => (process.env[k] ?? d) as string | undefined;
const envNum = (k: string, d: number) => Number(process.env[k] ?? d);
const envBool = (k: string, d = false) =>
  (process.env[k]?.toLowerCase() ?? '').match(/^(1|true|yes|y)$/) ? true : d;

const isProd = env('NODE_ENV', 'development') === 'production';
const databaseUrl = env('DATABASE_URL');

const options: DataSourceOptions = {
  type: 'postgres',
  schema: env('DB_SCHEMA', 'public'),
  synchronize: false,
  logging: envBool('DB_LOGGING', !isProd),
  migrationsTableName: env('DB_MIGRATIONS_TABLE', 'typeorm_migrations'),
  entities: [path.join(SRC, '**/*.entity.{ts,js}'), path.join(DIST, '**/*.entity.js')],
  migrations: [path.join(SRC, 'migrations/*.{ts,js}'), path.join(DIST, 'migrations/*.js')],
  ...(databaseUrl
    ? { url: databaseUrl }
    : {
        host: env('DB_HOST', 'localhost'),
        port: envNum('DB_PORT', 5432),
        username: env('DB_USER', 'postgres'),
        password: env('DB_PASS', 'postgres'),
        database: env('DB_NAME', 'kido'),
      }),
};

export default new DataSource(options); // ❗ chỉ 1 export duy nhất
