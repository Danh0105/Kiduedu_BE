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
  BadRequestException,
  ParseIntPipe,
  Query,
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
  findAll(
    @Query('page') page = '1',
    @Query('limit') limit = '10',
  ) {
    return this.ordersService.findAllPaginated(
      Number(page),
      Number(limit),
    );
  }


  // ====== LẤY ORDER THEO ID (INT THUẦN) ======
  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<Order> {
    return this.ordersService.findOne(id);
  }

  // ====== 🔥 API CHO MOMO (orderCode dạng: 186_1766...) ======
  @Public()
  @Get('by-code/:code')
  async findByCode(@Param('code') code: string): Promise<Order> {
    // code = "186_1766396065561"
    const realOrderId = Number(code.split('_')[0]);

    if (!Number.isInteger(realOrderId)) {
      throw new BadRequestException('Invalid order code');
    }

    const order = await this.ordersService.findOne(realOrderId);

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    return order;
  }

  @Patch(':id/status')
  updateStatus(
    @Param('id', ParseIntPipe) id: number,
    @Body() body: UpdateOrderStatusDto,
  ) {
    return this.ordersService.updateStatus(id, body.status);
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    await this.ordersService.remove(id);
    return { message: 'Order deleted successfully' };
  }

}
