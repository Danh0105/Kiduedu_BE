import { Controller, Post, Body } from '@nestjs/common';
import { MomoService } from './momo.service';

@Controller('momo')
export class MomoController {
  constructor(private readonly momoService: MomoService) { }

  @Post('create-payment')
  async createPayment(@Body() body: { amount: number; orderId: string }) {
    return this.momoService.createPayment(body.amount, body.orderId);
  }
  // 👇 Webhook callback từ MoMo
  @Post('payment-notify')
  async paymentNotify(@Body() body: any) {
    return this.momoService.handlePaymentNotify(body);
  }
}
