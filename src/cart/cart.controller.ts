import { Controller, Get, Post, Param, Body, Delete, Put } from '@nestjs/common';
import { CartService } from './cart.service';

@Controller('cart')
export class CartController {
  constructor(private readonly cartService: CartService) { }

  @Get(':userId')
  getCart(@Param('userId') userId: number) {
    return this.cartService.getCartByUser(+userId);
  }

  @Post(':userId/add')
  addItem(
    @Param('userId') userId: number,
    @Body() body: { productId: number; quantity: number },
  ) {
    return this.cartService.addItem(+userId, body.productId, body.quantity);
  }

  @Put(':userId/update')
  updateItem(
    @Param('userId') userId: number,
    @Body() body: { productId: number; quantity: number },
  ) {
    return this.cartService.updateItem(+userId, body.productId, body.quantity);
  }

  @Delete(':userId/remove/:productId')
  removeItem(@Param('userId') userId: number, @Param('productId') productId: number) {
    return this.cartService.removeItem(+userId, +productId);
  }

  @Delete(':userId/clear')
  clearCart(@Param('userId') userId: number) {
    return this.cartService.clearCart(+userId);
  }
}
