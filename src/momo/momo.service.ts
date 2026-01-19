import { BadRequestException, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';
import * as crypto from 'crypto';
import { Order } from '../orders/entities/order.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { number } from 'joi';
import { MomoIpnDto } from './momo.dto';

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
  async handlePaymentNotify(body: MomoIpnDto) {
    if (!this.verifyIpnSignature(body)) {
      console.error('❌ MOMO IPN SIGNATURE INVALID');
      return;
    }

    const realOrderId = Number(body.orderId.split('_')[0]);
    console.log(realOrderId);

    if (!Number.isSafeInteger(realOrderId)) {
      console.error('Invalid realOrderId:', realOrderId);
      return;
    }

    const order = await this.orderRepo.findOne({
      where: { orderId: realOrderId },
    });
    if (!order) return;

    // Idempotent
    if (order.paymentStatus === 'Paid') return;

    if (body.resultCode === 0) {
      order.paymentStatus = 'Paid';
      order.status = 'Confirmed';
      order.orderId = body.transId;
    } else {
      order.paymentStatus = 'Failed';
    }

    await this.orderRepo.save(order);
  }

  private verifyIpnSignature(body: MomoIpnDto): boolean {
    const rawSignature =
      `accessKey=${this.accessKey}` +
      `&amount=${body.amount}` +
      `&extraData=${body.extraData}` +
      `&message=${body.message}` +
      `&orderId=${body.orderId}` +
      `&orderInfo=${body.orderInfo}` +
      `&orderType=${body.orderType}` +
      `&partnerCode=${body.partnerCode}` +
      `&payType=${body.payType}` +
      `&requestId=${body.requestId}` +
      `&responseTime=${body.responseTime}` +
      `&resultCode=${body.resultCode}` +
      `&transId=${body.transId}`;

    const signature = crypto
      .createHmac('sha256', this.secretKey)
      .update(rawSignature)
      .digest('hex');

    return signature === body.signature;
  }


}
