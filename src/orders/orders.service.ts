import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import {
  Repository,
  DataSource,
  EntityManager,
} from 'typeorm';

import { Order } from './entities/order.entity';
import { OrderItem } from './entities/order-item.entity';
import { CreateOrderDto } from './dto/create-order.dto';

import { OrderStatus } from './order-status.enum';
import { canTransition } from './order-transition.rule';

import { ProductVariantInventory } from '../products/entities/product-variant-inventory.entity';
import { InventoryReceipt } from '../products/entities/inventory-receipt.entity';
import { InventoryReceiptItem } from '../products/entities/inventory-receipt-item.entity';
import { InventoryService } from 'src/products/services/inventory.service';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private readonly ordersRepo: Repository<Order>,

    @InjectRepository(OrderItem)
    private readonly orderItemsRepo: Repository<OrderItem>,

    private readonly inventoryService: InventoryService,

    private readonly dataSource: DataSource,
  ) { }

  // ===============================
  // CREATE ORDER
  // ===============================
  async create(data: CreateOrderDto): Promise<Order> {
    if (!data.items || data.items.length === 0) {
      throw new BadRequestException('Đơn hàng phải có ít nhất 1 sản phẩm');
    }

    const order = this.ordersRepo.create({
      userId: data.userId ?? null,
      promotionId: data.promotionId ?? null,

      subtotal: 0,
      discountAmount: 0,
      totalAmount: 0,

      status: OrderStatus.Pending,

      paymentMethod: data.paymentMethod ?? 'cod',
      paymentStatus:
        data.paymentMethod === 'cod'
          ? 'PENDING_PAYMENT'
          : 'PENDING_PAYMENT',
    });


    const savedOrder = await this.ordersRepo.save(order);

    const items = data.items.map((i) =>
      this.orderItemsRepo.create({
        orderId: savedOrder.orderId,
        variantId: i.variantId,
        quantity: i.quantity,
        pricePerUnit: i.pricePerUnit,
        attributes: i.attributes ?? {},
      }),
    );

    await this.orderItemsRepo.save(items);
    savedOrder.items = items;

    return savedOrder;
  }

  // ===============================
  // UPDATE STATUS + INVENTORY FLOW
  // ===============================
  async updateStatus(
    id: number,
    nextStatus: OrderStatus,
  ): Promise<Order> {

    return this.dataSource.transaction(async (manager) => {
      const order = await manager.getRepository(Order).findOne({
        where: { orderId: id },
        relations: [
          'items',
          'items.variant',
        ],
      });

      if (!order) {
        throw new NotFoundException('Order not found');
      }

      if (!canTransition(order.status as OrderStatus, nextStatus)) {
        throw new BadRequestException(
          `Không thể chuyển đơn từ ${order.status} sang ${nextStatus}`,
        );
      }

      // ===============================
      // PENDING → CONFIRMED : XUẤT KHO
      // ===============================
      if (
        order.status === OrderStatus.Pending &&
        nextStatus === OrderStatus.Confirmed
      ) {
        await this.inventoryService.create({
          type: 'export',
          date: new Date(),
          supplierId: null, // xuất nội bộ
          referenceNo: `ORDER-${order.orderId}`,
          note: 'Xuất kho theo đơn hàng',
          items: order.items.map((i) => {
            if (!i.variant) {
              throw new BadRequestException(
                `OrderItem ${i.orderItemId} thiếu variant`,
              );
            }

            return {
              variantId: i.variant.variantId,
              quantity: i.quantity,
              unitCost: i.pricePerUnit,
            };
          }),
        });
      }

      // ===============================
      // CONFIRMED → CANCELLED : HOÀN TỒN
      // ===============================
      if (
        order.status === OrderStatus.Confirmed &&
        nextStatus === OrderStatus.Cancelled
      ) {
        await this.inventoryService.create({
          type: 'import',
          date: new Date(),
          supplierId: null,
          referenceNo: `ORDER-${order.orderId}`,
          note: 'Hoàn tồn do huỷ đơn hàng',
          items: order.items.map((i) => {
            if (!i.variant) {
              throw new BadRequestException(
                `OrderItem ${i.orderItemId} thiếu variant`,
              );
            }

            return {
              variantId: i.variant.variantId,
              quantity: i.quantity,
              unitCost: i.pricePerUnit,
            };
          }),
        });
      }

      order.status = nextStatus;
      return manager.getRepository(Order).save(order);
    });
  }


  // ===============================
  // PHIẾU XUẤT KHO
  // ===============================
  private async createExportReceipt(
    manager: EntityManager,
    order: Order,
  ) {
    const receipt = manager.getRepository(InventoryReceipt).create({
      receiptCode: `XK-${order.orderId}-${Date.now()}`,
      receiptDate: new Date(),
      supplierId: 0,
      referenceNo: `ORDER-${order.orderId}`,
      note: 'Xuất kho theo đơn hàng',
      totalAmount: 0,
    });

    const saved = await manager.getRepository(InventoryReceipt).save(receipt);

    let total = 0;

    const items = order.items.map((item) => {
      const lineTotal = item.quantity * item.pricePerUnit;
      total += lineTotal;
      if (!item.variant) {
        throw new BadRequestException(
          `OrderItem thiếu variant (orderId=${order.orderId})`,
        );
      }

      return manager.getRepository(InventoryReceiptItem).create({
        receiptId: saved.receiptId,
        variantId: item.variant.variantId,
        quantity: item.quantity,
        unitCost: item.pricePerUnit,
        lineTotal,
      });
    });

    await manager.getRepository(InventoryReceiptItem).save(items);

    saved.totalAmount = total;
    await manager.getRepository(InventoryReceipt).save(saved);
  }

  // ===============================
  // PHIẾU NHẬP KHO (HOÀN TỒN)
  // ===============================
  private async createRestoreReceipt(
    manager: EntityManager,
    order: Order,
  ) {
    const receipt = manager.getRepository(InventoryReceipt).create({
      receiptCode: `NT-${order.orderId}-${Date.now()}`,
      receiptDate: new Date(),
      supplierId: 0,
      referenceNo: `ORDER-${order.orderId}`,
      note: 'Hoàn tồn do huỷ đơn hàng',
      totalAmount: 0,
    });

    const saved = await manager.getRepository(InventoryReceipt).save(receipt);

    let total = 0;

    const items = order.items.map((item) => {
      const lineTotal = item.quantity * item.pricePerUnit;
      total += lineTotal;
      if (!item.variant) {
        throw new BadRequestException(
          `OrderItem thiếu variant (orderId=${order.orderId})`,
        );
      }

      return manager.getRepository(InventoryReceiptItem).create({
        receiptId: saved.receiptId,
        variantId: item.variant.variantId,
        quantity: item.quantity,
        unitCost: item.pricePerUnit,
        lineTotal,
      });
    });

    await manager.getRepository(InventoryReceiptItem).save(items);

    saved.totalAmount = total;
    await manager.getRepository(InventoryReceipt).save(saved);
  }
  async findAll(): Promise<Order[]> {
    return this.ordersRepo.find({
      relations: [
        'items',
        'items.variant',
        'items.variant.product',
        'user',
        'promotion',
      ],
      order: { orderDate: 'DESC' },
    });
  }
  async findOne(id: number): Promise<Order> {
    const order = await this.ordersRepo.findOne({
      where: { orderId: id },
      relations: [
        'items',
        'items.variant',
        'items.variant.product',
        'user',
        'promotion',
      ],
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    return order;
  }
  async remove(id: number): Promise<void> {
    const order = await this.findOne(id);

    if (order.status !== OrderStatus.Pending) {
      throw new BadRequestException(
        'Chỉ được xoá đơn hàng ở trạng thái Pending',
      );
    }
    await this.ordersRepo.remove(order);
  }
  async findByCode(code: number): Promise<Order | null> {
    return this.ordersRepo.findOne({
      where: { orderId: code },
      relations: [
        'items',
        'items.variant',
        'items.variant.product',
        'shippingAddress',
        'user',
      ],
    });
  }

}
