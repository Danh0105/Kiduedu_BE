import { DataSource } from 'typeorm';
import { User } from './users/entities/user.entity'; // import các entity của bạn

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.POSTGRES_HOST ?? 'localhost',
  port: parseInt(process.env.POSTGRES_PORT ?? '5432', 10),
  username: process.env.POSTGRES_USER ?? 'postgres',
  password: process.env.POSTGRES_PASSWORD ?? 'postgres',
  database: process.env.POSTGRES_DB ?? 'nestjs_db',
  synchronize: false, // ⚠️ phải tắt khi dùng migration
  logging: true,
  entities: [User, __dirname + '/**/*.entity{.ts,.js}'],
  migrations: [__dirname + '/migrations/*{.ts,.js}'],
});
