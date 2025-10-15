import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { ProductModule } from './products/product.module';
import { CategoriesModule } from './categories/category.module';
import { OrdersModule } from './orders/order.module';
import { PromotionsModule } from './promotions/promotions.module';
import { CartModule } from './cart/cart.module';
import { StatisticsModule } from './statistics/statistics.module';
import { ConfigModule } from '@nestjs/config';
/* import { OpenaiModule } from './gpt/openai.module';
 */import { MomoModule } from './momo/momo.module';
import { SearchModule } from './search/search.module';
import { BannerModule } from './banners/banner.module';
@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.POSTGRES_HOST,
      port: parseInt(process.env.POSTGRES_PORT || '5432', 10),
      username: process.env.POSTGRES_USER,
      password: process.env.POSTGRES_PASSWORD,
      database: process.env.POSTGRES_DB,
      autoLoadEntities: true,
      synchronize: true,
      migrations: ['dist/migrations/*.js'],
    }),
    AuthModule,
    ProductModule,
    CategoriesModule,
    OrdersModule,
    PromotionsModule,
    CartModule,
    StatisticsModule,
    BannerModule,
    /*  OpenaiModule, */
    MomoModule,
    SearchModule,
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env'], // đảm bảo .env nằm cùng thư mục khi pm2 start
    }),
  ],
  controllers: [AppController],
  providers: [AppService],

})
export class AppModule { }

