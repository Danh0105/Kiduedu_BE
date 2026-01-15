import { Controller, Post, Body, HttpCode } from '@nestjs/common';
import { MomoService } from './momo.service';
import { MomoIpnDto } from './momo.dto';

@Controller('momo')
export class MomoController {
  constructor(private readonly momoService: MomoService) { }

  @Post('create-payment')
  async createPayment(@Body() body: { amount: number; orderId: number }) {
    console.log("orderId", body.orderId);

    return this.momoService.createPayment(body.amount, body.orderId);
  }
  @Post('payment-notify')
  @HttpCode(204)
  async paymentNotify(@Body() body: MomoIpnDto) {
    await this.momoService.handlePaymentNotify(body);
  }
}
