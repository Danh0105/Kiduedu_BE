import { BadRequestException, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';
import * as crypto from 'crypto';
import { Order } from '../orders/entities/order.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { number } from 'joi';

@Injectable()
export class MomoService {

  private partnerCode: string;
  private accessKey: string;
  private secretKey: string;
  private endpoint: string;

  constructor(
    private configService: ConfigService,
    @InjectRepository(Order)
    private readonly orderRepo: Repository<Order>,
  ) {
    this.partnerCode = this.configService.get<string>('MOMO_PARTNER_CODE', '');
    this.accessKey = this.configService.get<string>('MOMO_ACCESS_KEY', '');
    this.secretKey = this.configService.get<string>('MOMO_SECRET_KEY', '');
    this.endpoint = 'https://payment.momo.vn/v2/gateway/api/create';

  }

  async createPayment(amount: number, orderId: number) {
    if (!Number.isInteger(orderId)) {
      throw new BadRequestException('Invalid orderId');
    }

    const requestId = Date.now().toString();
    const orderInfo = 'Thanh toán thử nghiệm';

    // FE nhận redirect
    const redirectUrl = 'https://www.kidoedu.edu.vn/payment-result';

    // BE nhận IPN
    const ipnUrl = 'https://kidoedu.vn/momo/payment-notify';

    const requestType = 'captureWallet';

    // 👉 orderId MoMo (string)
    const momoOrderId = `${orderId}_${requestId}`;

    const rawSignature =
      `accessKey=${this.accessKey}` +
      `&amount=${amount}` +
      `&extraData=` +
      `&ipnUrl=${ipnUrl}` +
      `&orderId=${momoOrderId}` +
      `&orderInfo=${orderInfo}` +
      `&partnerCode=${this.partnerCode}` +
      `&redirectUrl=${redirectUrl}` +
      `&requestId=${requestId}` +
      `&requestType=${requestType}`;

    const signature = crypto
      .createHmac('sha256', this.secretKey)
      .update(rawSignature)
      .digest('hex');

    const requestBody = {
      partnerCode: this.partnerCode,
      accessKey: this.accessKey,
      requestId,
      amount,
      orderId: momoOrderId,
      orderInfo,
      redirectUrl,
      ipnUrl,
      requestType,
      extraData: '',
      lang: 'vi',
      signature,
    };

    const response = await axios.post(this.endpoint, requestBody);
    return response.data;
  }

  /* =========================================================
     IPN / WEBHOOK
     ========================================================= */
  async handlePaymentNotify(body: any) {
    console.log('📩 IPN BODY:', body);

    const { orderId, resultCode } = body;

    const realOrderId = Number(orderId.split('_')[0]);

    const order = await this.orderRepo.findOne({
      where: { orderId: realOrderId },
    });

    if (!order) {
      return { resultCode: 99, message: 'Order not found' };
    }

    // idempotent
    if (order.paymentStatus === 'Paid') {
      return { resultCode: 0, message: 'Already processed' };
    }

    if (resultCode === 0) {
      order.paymentStatus = 'Paid';
      order.status = 'Confirmed';
    } else {
      order.paymentStatus = 'Failed';
    }

    await this.orderRepo.save(order);

    return { resultCode: 0, message: 'OK' };
  }

}
