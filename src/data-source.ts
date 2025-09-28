import 'reflect-metadata';
import { DataSource } from 'typeorm';

export default new DataSource({
  type: 'postgres',
  host: '163.223.211.23',
  port: 5432,
  username: 'admin',
  password: 'secret',
  database: 'mydb',
  entities: ['src/**/*.entity.ts'],
  migrations: ['src/migrations/*.ts'],
  migrationsTableName: 'typeorm_migrations', // 👈 tránh trùng với bảng domain `public.migrations`
  synchronize: false,
  logging: false,
});
