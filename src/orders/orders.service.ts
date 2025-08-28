import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from './entities/order.entity';
import { OrderItem } from './entities/order-item.entity';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order) private readonly orderRepo: Repository<Order>,
    @InjectRepository(OrderItem) private readonly orderItemRepo: Repository<OrderItem>,
  ) { }

  async findAll(): Promise<Order[]> {
    return this.orderRepo.find({ relations: ['items', 'items.product', 'user'] });
  }

  async findOne(id: number): Promise<Order> {
    const order = await this.orderRepo.findOne({
      where: { order_id: id },
      relations: ['items', 'items.product', 'user']
    });
    if (!order) throw new NotFoundException('Order not found');
    return order;
  }

  async create(orderData: Partial<Order>): Promise<Order> {
    const order = this.orderRepo.create(orderData);
    return this.orderRepo.save(order);
  }

  async remove(id: number): Promise<void> {
    const order = await this.findOne(id);
    await this.orderRepo.remove(order);
  }
}
