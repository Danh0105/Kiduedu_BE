import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from '../orders/entities/order.entity';
import { OrderItem } from '../orders/entities/order-item.entity';
import { User } from '../users/entities/user.entity';
import { Product } from '../products/entities/product.entity';

@Injectable()
export class StatisticsService {
  constructor(
    @InjectRepository(Order) private ordersRepo: Repository<Order>,
    @InjectRepository(OrderItem) private orderItemsRepo: Repository<OrderItem>,
    @InjectRepository(User) private usersRepo: Repository<User>,
    @InjectRepository(Product) private productsRepo: Repository<Product>,
  ) { }

  /** Doanh thu theo tháng */
  async revenueByMonth(year: number) {
    return this.ordersRepo.query(
      `
      SELECT DATE_TRUNC('month', order_date) AS month,
             SUM(total_amount) AS revenue
      FROM orders
      WHERE status IN ('Shipped', 'Completed') AND EXTRACT(YEAR FROM order_date) = $1
      GROUP BY month
      ORDER BY month
      `,
      [year],
    );
  }

  /** Top sản phẩm bán chạy */
  async topProducts(limit = 5) {
    return this.orderItemsRepo.query(
      `
      SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_sold
      FROM order_items oi
      JOIN products p ON p.product_id = oi.product_id
      GROUP BY p.product_id, p.product_name
      ORDER BY total_sold DESC
      LIMIT $1
      `,
      [limit],
    );
  }

  /** Top khách hàng chi tiêu nhiều */
  async topCustomers(limit = 5) {
    return this.ordersRepo.query(
      `
      SELECT u.user_id, u.username, SUM(o.total_amount) AS total_spent
      FROM orders o
      JOIN users u ON u.user_id = o.user_id
      WHERE o.status IN ('Shipped', 'Completed')
      GROUP BY u.user_id, u.username
      ORDER BY total_spent DESC
      LIMIT $1
      `,
      [limit],
    );
  }

  /** Thống kê số đơn theo trạng thái */
  async orderStatusCount() {
    return this.ordersRepo.query(
      `
      SELECT status, COUNT(*) AS total
      FROM orders
      GROUP BY status
      `,
    );
  }
}
