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
@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'admin',
      password: 'secret',
      database: 'mydb',
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
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }

