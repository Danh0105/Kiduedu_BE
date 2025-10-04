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
import { OpenaiModule } from './gpt/openai.module';
import { MomoModule } from './momo/momo.module';
import { SearchModule } from './search/search.module';
import { SearchController } from './search/search.controller';
import { SearchService } from './search/search.service';
@Module({
  imports: [
    TypeOrmModule.forRoot({ /* ... */ }),
    AuthModule,
    ProductModule,
    CategoriesModule,
    OrdersModule,
    PromotionsModule,
    CartModule,
    StatisticsModule,
    OpenaiModule,
    MomoModule,
    SearchModule,                 // <-- chỉ cần import module
    ConfigModule.forRoot({ isGlobal: true }),
  ],
  controllers: [AppController],   // <-- bỏ SearchController ở đây
  providers: [AppService],      // <-- bỏ SearchService ở đây
})
export class AppModule { }

