import { Controller, Post, Body } from '@nestjs/common';
import { MomoService } from './momo.service';

@Controller('momo')
export class MomoController {
  constructor(private readonly momoService: MomoService) { }

  @Post('create-payment')
  async createPayment(@Body() body: { amount: number; orderId: number }) {
    console.log("orderId", body.orderId);

    return this.momoService.createPayment(body.amount, body.orderId);
  }
  @Post('payment-notify')
  async paymentNotify(@Body() body: any) {
    return this.momoService.handlePaymentNotify(body);
  }
}
