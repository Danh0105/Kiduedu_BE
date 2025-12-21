import { Injectable } from '@nestjs/common';
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
    this.endpoint = 'https://test-payment.momo.vn/v2/gateway/api/create';

  }

  async createPayment(amount: number, orderId: number) {
    const requestId = Date.now().toString();
    const orderInfo = 'Thanh toán thử nghiệm';
    const redirectUrl = 'http://localhost:3001/payment-result';
    const ipnUrl = 'http://localhost:3000/momo/payment-notify';
    const requestType = 'captureWallet';

    const momoOrderId = `${orderId}_${requestId}`;

    const rawSignature =
      `accessKey=${this.accessKey}&amount=${amount}&extraData=&ipnUrl=${ipnUrl}` +
      `&orderId=${momoOrderId}&orderInfo=${orderInfo}&partnerCode=${this.partnerCode}` +
      `&redirectUrl=${redirectUrl}&requestId=${requestId}&requestType=${requestType}`;

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


  async handlePaymentNotify(body: any) {
    const {
      orderId,
      resultCode,
      signature,
      amount,
      partnerCode,
      requestId,
      orderInfo,
      orderType,
      transId,
      message,
      payType,
      responseTime,
      extraData,
    } = body;

    const rawSignature =
      `amount=${amount}&extraData=${extraData}&message=${message}` +
      `&orderId=${orderId}&orderInfo=${orderInfo}&orderType=${orderType}` +
      `&partnerCode=${partnerCode}&payType=${payType}&requestId=${requestId}` +
      `&responseTime=${responseTime}&resultCode=${resultCode}&transId=${transId}`;

    const expectedSignature = crypto
      .createHmac('sha256', this.secretKey)
      .update(rawSignature)
      .digest('hex');

    if (expectedSignature !== signature) {
      return { resultCode: 99, message: 'Invalid signature' };
    }

    // 🔥 CHUYỂN orderId → number
    const orderIdNum = Number(orderId);

    if (!Number.isFinite(orderIdNum)) {
      return { resultCode: 99, message: 'Invalid orderId' };
    }

    if (resultCode === 0) {
      await this.orderRepo.update(
        { orderId: orderIdNum },
        {
          paymentStatus: 'PAID',
          status: 'Confirmed',
        }
      );
    } else {
      await this.orderRepo.update(
        { orderId: orderIdNum },
        { paymentStatus: 'FAILED' }
      );
    }

    return {
      resultCode: 0,
      message: 'Confirm Success',
    };
  }

}
