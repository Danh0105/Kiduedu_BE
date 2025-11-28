import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from './entities/order.entity';
import { OrderItem } from './entities/order-item.entity';
import { CreateOrderDto } from './dto/create-order.dto';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private readonly ordersRepo: Repository<Order>,

    @InjectRepository(OrderItem)
    private readonly orderItemsRepo: Repository<OrderItem>,
  ) { }

  async create(data: CreateOrderDto): Promise<Order> {
    if (!data.items || data.items.length === 0) {
      throw new BadRequestException('Đơn hàng phải có ít nhất 1 sản phẩm');
    }

    const subtotal = 0;/* data.items.reduce(
      (sum, i) => sum + i.pricePerUnit * i.quantity,
      0,
    ); */
    const discountAmount = 0;
    const totalAmount = subtotal - discountAmount;

    // 🧾 Tạo Order – chỉ dùng các field có trong entity
    const order = this.ordersRepo.create({
      userId: data.userId ?? null,
      promotionId: data.promotionId ?? null,
      subtotal,
      discountAmount,
      totalAmount,
      status: 'Pending',
    });

    const savedOrder: Order = await this.ordersRepo.save(order);

    // 📦 Tạo OrderItems gắn vào order vừa tạo
    const orderItems: OrderItem[] = data.items.map((i) =>
      this.orderItemsRepo.create({
        order: savedOrder,
        orderId: savedOrder.orderId,
        variantId: i.variantId,
        quantity: i.quantity,
        pricePerUnit: i.pricePerUnit,
        attributes: i.attributes ?? {},
      }),
    );

    await this.orderItemsRepo.save(orderItems);

    savedOrder.items = orderItems;
    return savedOrder;
  }

  async findAll(): Promise<Order[]> {
    return this.ordersRepo.find({
      relations: ['items', 'items.variant', 'user', 'promotion', 'items.variant.product'],
      order: { orderDate: 'DESC' },
    });
  }

  async findOne(id: number): Promise<Order> {
    const order = await this.ordersRepo.findOne({
      where: { orderId: id },
      relations: ['items', 'items.variant', 'user', 'promotion', 'items.variant.product'],
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
