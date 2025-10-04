import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';
import * as crypto from 'crypto';

@Injectable()
export class MomoService {
  private partnerCode: string;
  private accessKey: string;
  private secretKey: string;
  private endpoint: string;

  constructor(private configService: ConfigService) {
    this.partnerCode = this.configService.get<string>('MOMO_PARTNER_CODE', '');
    this.accessKey = this.configService.get<string>('MOMO_ACCESS_KEY', '');
    this.secretKey = this.configService.get<string>('MOMO_SECRET_KEY', '');
    this.endpoint = 'https://test-payment.momo.vn/v2/gateway/api/create';
  }

  async createPayment(amount: number, orderId: string) {
    const requestId = Date.now().toString();
    const orderInfo = 'Thanh toán thử nghiệm';
    const redirectUrl = 'http://localhost:3000/invoice';
    const ipnUrl = 'http://localhost:3000/payment-notify';
    const requestType = 'captureWallet';

    // Nếu client truyền orderId thì dùng, không thì tự generate
    const finalOrderId = orderId || `order_${requestId}`;

    const rawSignature =
      `accessKey=${this.accessKey}&amount=${amount}&extraData=&ipnUrl=${ipnUrl}&orderId=${finalOrderId}&orderInfo=${orderInfo}&partnerCode=${this.partnerCode}&redirectUrl=${redirectUrl}&requestId=${requestId}&requestType=${requestType}`;

    const signature = crypto
      .createHmac('sha256', this.secretKey)
      .update(rawSignature)
      .digest('hex');

    const requestBody = {
      partnerCode: this.partnerCode,
      accessKey: this.accessKey,
      requestId,
      amount,
      orderId: finalOrderId,
      orderInfo,
      redirectUrl,
      ipnUrl,
      requestType,
      extraData: '',
      signature,
    };

    const https = require('https');
    const response = await axios.post(this.endpoint, requestBody, {
      httpsAgent: new https.Agent({ rejectUnauthorized: false }),
    });

    return response.data;
  }

  async handlePaymentNotify(body: any) {
    const {
      partnerCode,
      orderId,
      requestId,
      amount,
      orderInfo,
      orderType,
      transId,
      resultCode,
      message,
      payType,
      responseTime,
      extraData,
      signature,
    } = body;

    // ✅ Verify chữ ký để đảm bảo callback từ MoMo là hợp lệ
    const rawSignature =
      `amount=${amount}&extraData=${extraData}&message=${message}&orderId=${orderId}&orderInfo=${orderInfo}&orderType=${orderType}&partnerCode=${partnerCode}&payType=${payType}&requestId=${requestId}&responseTime=${responseTime}&resultCode=${resultCode}&transId=${transId}`;

    const expectedSignature = crypto
      .createHmac('sha256', this.secretKey)
      .update(rawSignature)
      .digest('hex');

    if (expectedSignature !== signature) {
      return { resultCode: 99, message: 'Invalid signature' };
    }

    // ✅ Giải mã extraData (chi tiết sản phẩm)
    let products = [];
    if (extraData) {
      try {
        products = JSON.parse(Buffer.from(extraData, 'base64').toString('utf8'));
      } catch (e) {
        products = [];
      }
    }

    // ✅ Lưu kết quả thanh toán vào DB (giả lập)
    if (resultCode === 0) {
      console.log('Thanh toán thành công:', { orderId, amount, products });
      // TODO: Update order status = "PAID" trong DB
    } else {
      console.log('Thanh toán thất bại:', { orderId, message });
      // TODO: Update order status = "FAILED" trong DB
    }

    // ✅ MoMo yêu cầu luôn trả JSON response với `resultCode = 0`
    return {
      resultCode: 0,
      message: 'Confirm Success',
    };
  }
}
