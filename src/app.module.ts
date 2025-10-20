import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import * as Joi from 'joi';
import { SearchModule } from './search/search.module';
import { MomoModule } from './momo/momo.module';
import { StatisticsModule } from './statistics/statistics.module';
import { CartModule } from './cart/cart.module';
import { PromotionsModule } from './promotions/promotions.module';
import { OrdersModule } from './orders/order.module';
import { CategoriesModule } from './categories/category.module';
import { ProductModule } from './products/product.module';
import { AuthModule } from './auth/auth.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PolicyModule } from './policy/policy.module';
import { CustomerServiceModule } from './customer-service/customer-service.module';
import { FeedbackModule } from './feedback/feedback.module';
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
        NODE_ENV: Joi.string()
          .valid('development', 'production', 'test')
          .default('development'),
      }),
    }),

    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (cfg: ConfigService) => {
        const isProd = cfg.get<'development' | 'production' | 'test'>('NODE_ENV') === 'production';
        return {
          type: 'postgres',
          host: cfg.get<string>('POSTGRES_HOST'),
          port: cfg.get<number>('POSTGRES_PORT'),
          username: cfg.get<string>('POSTGRES_USER'),
          password: cfg.get<string>('POSTGRES_PASSWORD'),
          database: cfg.get<string>('POSTGRES_DB'),

          // Giúp HMR/dev không bị đóng connection khi reload
          keepConnectionAlive: true,

          // Pool & timeout: giảm khả năng “terminated unexpectedly” do mạng chập chờn
          extra: {
            application_name: 'nestjs-local',
            statement_timeout: 0,            // 0 = no timeout cho câu lệnh
            idle_in_transaction_session_timeout: 0,
            // Kết nối qua Internet: nên bật keepalive
            keepAlive: true,                 // node-postgres TCP keepalive
            connectionTimeoutMillis: 10000,  // 10s
            idleTimeoutMillis: 30000,        // 30s
            max: 10,                         // pool size
          },

          // Bạn chưa bật TLS ở phía Postgres => để false.
          // Nếu sau này bật TLS, đổi thành: ssl: { rejectUnauthorized: true, ca: fs.readFileSync('ca.pem') }
          ssl: false,

          // Tự load entity khi dev
          autoLoadEntities: true,
          synchronize: !isProd,

          // Tăng khả năng hồi phục khi DB vừa khởi động xong
          retryAttempts: 10,
          retryDelay: 2000,

          // Bật log khi cần debug
          logging: !isProd ? ['error', 'warn'] : ['error'],

          migrations: ['dist/migrations/*.js'],
        };
      },
    }),

    AuthModule,
    ProductModule,
    CategoriesModule,
    OrdersModule,
    PromotionsModule,
    CartModule,
    StatisticsModule,
    FeedbackModule,
    /*  OpenaiModule, */
    MomoModule,
    SearchModule,
    PolicyModule,
    CustomerServiceModule,
    ConfigModule.forRoot({ isGlobal: true }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
