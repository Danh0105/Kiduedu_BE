import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Cart } from './entities/cart.entity';
import { CartItem } from './entities/cart-item.entity';
import { User } from '../users/entities/user.entity';
import { Product } from '../products/entities/product.entity';

@Injectable()
export class CartService {
  constructor(
    @InjectRepository(Cart) private readonly cartRepo: Repository<Cart>,
    @InjectRepository(CartItem) private readonly cartItemRepo: Repository<CartItem>,
  ) { }

  async getCartByUser(userId: number): Promise<Cart> {
    const cart = await this.cartRepo.findOne({
      where: { user: { user_id: userId } },
      relations: ['items', 'items.product'],
    });

    if (!cart) {
      const newCart = this.cartRepo.create({ user: { user_id: userId } as User });
      return this.cartRepo.save(newCart);
    }

    return cart;
  }

  async addItem(userId: number, productId: number, quantity: number): Promise<Cart> {
    const cart = await this.getCartByUser(userId);

    let item = await this.cartItemRepo.findOne({
      where: { cart: { cart_id: cart.cart_id }, product: { product_id: productId } },
      relations: ['product'],
    });

    if (item) {
      item.quantity += quantity;
    } else {
      item = this.cartItemRepo.create({
        cart,
        product: { product_id: productId } as Product,
        quantity,
      });
    }

    await this.cartItemRepo.save(item);
    return this.getCartByUser(userId);
  }

  async updateItem(userId: number, productId: number, quantity: number): Promise<Cart> {
    const cart = await this.getCartByUser(userId);
    const item = await this.cartItemRepo.findOne({
      where: { cart: { cart_id: cart.cart_id }, product: { product_id: productId } },
    });

    if (!item) throw new NotFoundException('Item not found in cart');
    item.quantity = quantity;

    await this.cartItemRepo.save(item);
    return this.getCartByUser(userId);
  }

  async removeItem(userId: number, productId: number): Promise<Cart> {
    const cart = await this.getCartByUser(userId);
    await this.cartItemRepo.delete({
      cart: { cart_id: cart.cart_id },
      product: { product_id: productId },
    });

    return this.getCartByUser(userId);
  }

  async clearCart(userId: number): Promise<void> {
    const cart = await this.getCartByUser(userId);
    await this.cartItemRepo.delete({ cart: { cart_id: cart.cart_id } });
  }
}
