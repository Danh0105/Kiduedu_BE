import { Controller, Get, Query } from '@nestjs/common';
import { StatisticsService } from './statistics.service';
import { Public } from 'src/auth/public.decorator';

@Controller('statistics')
export class StatisticsController {
  constructor(private readonly statisticsService: StatisticsService) { }
  @Public()
  @Get('revenue-by-month')
  async revenueByMonth(@Query('year') year: number) {
    return this.statisticsService.revenueByMonth(year || new Date().getFullYear());
  }

  @Get('top-products')
  async topProducts(@Query('limit') limit: number) {
    return this.statisticsService.topProducts(limit || 5);
  }

  @Get('top-customers')
  async topCustomers(@Query('limit') limit: number) {
    return this.statisticsService.topCustomers(limit || 5);
  }

  @Get('order-status')
  async orderStatus() {
    return this.statisticsService.orderStatusCount();
  }
}
