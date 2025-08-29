import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from './entities/order.entity';
import { OrderItem } from './entities/order-item.entity';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private readonly ordersRepo: Repository<Order>,

    @InjectRepository(OrderItem)
    private readonly orderItemsRepo: Repository<OrderItem>,
  ) { }

  async create(data: {
    user_id: number;
    shipping_address: string;
    promotion_id?: number;
    items: { product_id: number; quantity: number; price_per_unit: number }[];
  }): Promise<Order> {
    const subtotal = data.items.reduce(
      (sum, i) => sum + i.price_per_unit * i.quantity,
      0,
    );

    const discount = 0;
    const total = subtotal - discount;

    // ✅ Tạo order
    const order = this.ordersRepo.create({
      user: { user_id: data.user_id } as any, // dùng relation
      shipping_address: data.shipping_address,
      subtotal,
      discount_amount: discount,
      total_amount: total,
      status: 'Pending',
      promotion: data.promotion_id
        ? ({ promotion_id: data.promotion_id } as any)
        : null,
    });

    // ✅ Lưu order (chắc chắn trả về Order, không phải Order[])
    const savedOrder: Order = await this.ordersRepo.save(order);

    // ✅ Tạo order_items
    const items = data.items.map((i) =>
      this.orderItemsRepo.create({
        order: savedOrder,
        product: { product_id: i.product_id } as any,
        quantity: i.quantity,
        price_per_unit: i.price_per_unit,
      }),
    );

    await this.orderItemsRepo.save(items);

    savedOrder.items = items;
    return savedOrder;
  }

  async findAll(): Promise<Order[]> {
    return this.ordersRepo.find({
      relations: ['items'],
    });
  }

  async findOne(id: number): Promise<Order> {
    const order = await this.ordersRepo.findOne({
      where: { order_id: id },
      relations: ['items'],
    });
    if (!order) throw new NotFoundException('Order not found');
    return order;
  }

  async updateStatus(id: number, status: string): Promise<Order> {
    const order = await this.findOne(id);
    order.status = status;
    return this.ordersRepo.save(order);
  }

  async remove(id: number): Promise<void> {
    const order = await this.findOne(id);
    await this.ordersRepo.remove(order);
  }
}
