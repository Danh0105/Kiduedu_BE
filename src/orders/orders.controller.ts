// orders.controller.ts
import {
  Controller,
  Post,
  Body,
  Get,
  Param,
  Put,
  Delete,
} from '@nestjs/common';
import { OrdersService } from './orders.service';
import { Order } from './entities/order.entity';
import { Public } from '../auth/public.decorator';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderStatusDto } from './dto/update-order-status.dto';

@Controller('orders')
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) { }

  @Public()
  @Post()
  async create(@Body() body: CreateOrderDto): Promise<Order> {
    return this.ordersService.create(body);
  }

  @Get()
  async findAll(): Promise<Order[]> {
    return this.ordersService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: number): Promise<Order> {
    return this.ordersService.findOne(+id);
  }

  @Put(':id/status')
  async updateStatus(
    @Param('id') id: number,
    @Body() body: UpdateOrderStatusDto,
  ): Promise<Order> {
    return this.ordersService.updateStatus(+id, body.status);
  }

  @Delete(':id')
  async remove(@Param('id') id: number): Promise<{ message: string }> {
    await this.ordersService.remove(+id);
    return { message: 'Order deleted successfully' };
  }
}
