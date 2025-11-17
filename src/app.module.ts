import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import * as Joi from 'joi';

import { SearchModule } from './search/search.module';
import { MomoModule } from './momo/momo.module';
import { StatisticsModule } from './statistics/statistics.module';
import { CartModule } from './cart/cart.module';
import { PromotionsModule } from './promotions/promotions.module';
/* import { OrdersModule } from './orders/order.module';
 */import { CategoriesModule } from './categories/category.module';
import { ProductModule } from './products/product.module';
import { AuthModule } from './auth/auth.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PolicyModule } from './policy/policy.module';
import { CustomerServiceModule } from './customer-service/customer-service.module';
import { FeedbackModule } from './feedback/feedback.module';
import { OrdersModule } from './orders/order.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env'],
      validationSchema: Joi.object({
        POSTGRES_HOST: Joi.string().required(),
        POSTGRES_PORT: Joi.number().default(5432),
        POSTGRES_USER: Joi.string().required(),
        POSTGRES_PASSWORD: Joi.string().required(),
        POSTGRES_DB: Joi.string().required(),
        NODE_ENV: Joi.string().valid('development', 'production', 'test').default('development'),
      }),
    }),

    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (cfg: ConfigService) => {
        const isProd = cfg.get<'development' | 'production' | 'test'>('NODE_ENV') === 'production';
        return {
          type: 'postgres',
          host: cfg.get<string>('POSTGRES_HOST', '127.0.0.1'),
          port: Number(cfg.get<string>('POSTGRES_PORT', '5432')),
          username: cfg.get<string>('POSTGRES_USER', 'postgres'),
          password: cfg.get<string>('POSTGRES_PASSWORD', 'postgres'),
          database: cfg.get<string>('POSTGRES_DB', 'nestjs_db'),

          keepConnectionAlive: true,
          extra: {
            application_name: 'nestjs-app',
            keepAlive: true,
            connectionTimeoutMillis: 10000,
            idleTimeoutMillis: 30000,
            max: 10,
          },
          ssl: { rejectUnauthorized: false },
          autoLoadEntities: true,
          synchronize: false,
          dropSchema: false,
          retryAttempts: 10,
          retryDelay: 2000,
          logging: isProd ? ['error'] : ['error', 'warn'],
          migrations: ['dist/migrations/*.js'],

        };
      },
    }),

    AuthModule,
    ProductModule,
    CategoriesModule,
/*     OrdersModule,
 */    PromotionsModule,
    CartModule,
    StatisticsModule,
    FeedbackModule,
    MomoModule,
    SearchModule,
    PolicyModule,
    CustomerServiceModule,
    OrdersModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
