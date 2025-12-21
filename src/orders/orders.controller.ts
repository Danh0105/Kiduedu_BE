// orders.controller.ts
import {
  Controller,
  Post,
  Body,
  Get,
  Param,
  Delete,
  Patch,
  NotFoundException,
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

  // 🔥🔥🔥 API MỚI – LẤY ORDER THEO orderCode (CHO MOMO)
  @Public()
  @Get('by-code/:code')
  async findByCode(@Param('code') code: number): Promise<Order> {
    const order = await this.ordersService.findByCode(code);

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    return order;
  }

  @Patch(':id/status')
  updateStatus(
    @Param('id') id: string,
    @Body() body: UpdateOrderStatusDto,
  ) {
    return this.ordersService.updateStatus(+id, body.status);
  }

  @Delete(':id')
  async remove(@Param('id') id: number): Promise<{ message: string }> {
    await this.ordersService.remove(+id);
    return { message: 'Order deleted successfully' };
  }
}
