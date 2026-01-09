import { VNPay, dateFormat, ReturnQueryFromVNPay, VnpCurrCode } from 'vnpay';
import { ProductCode, VnpLocale } from 'vnpay/enums';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from 'src/orders/entities/order.entity';
import * as crypto from 'crypto';
import * as qs from 'qs';
import { Request } from 'express';
@Injectable()
export class VnpayService {
    constructor(
        private readonly configService: ConfigService,

        @InjectRepository(Order)
        private readonly orderRepo: Repository<Order>,
    ) { }

    async createPaymentUrl(body: {
        amount: number;
        orderId: string;
        orderDescription?: string;
        orderType?: string;
        bankCode?: string;
    }) {
        const vnpay = new VNPay({
            tmnCode: this.configService.get<string>('VNP_TMNCODE')!,
            secureSecret: this.configService.get<string>('VNP_HASHSECRET')!,
            vnpayHost: this.configService.get<string>('VNP_URL'),
            testMode: true,
            vnp_Locale: VnpLocale.VN,
            vnp_OrderType: ProductCode.Other,
        });

        const payUrl = await vnpay.buildPaymentUrl({
            // ===== GIỮ NGUYÊN =====
            vnp_Amount: body.amount,
            vnp_IpAddr: '127.0.0.1',
            vnp_TxnRef: body.orderId,
            vnp_OrderInfo:
                body.orderDescription ?? `Thanh toan don hang #${body.orderId}`,
            vnp_ReturnUrl: this.configService.get<string>('VNP_RETURNURL')!,
            vnp_BankCode: body.bankCode,
            vnp_CreateDate: dateFormat(new Date()),
            vnp_ExpireDate: dateFormat(new Date(Date.now() + 15 * 60 * 1000)),

            vnp_CurrCode: 'VND' as VnpCurrCode,
            vnp_Locale: 'vn' as VnpLocale,
            vnp_OrderType: 'billpayment' as ProductCode,

        });



        // 🔥 QUAN TRỌNG: wrap lại cho FE
        return {
            payUrl,
        };

    }
    verifyReturn(query: Record<string, string>) {
        const vnpay = new VNPay({
            tmnCode: this.configService.get<string>('VNP_TMNCODE')!,
            secureSecret: this.configService.get<string>('VNP_HASHSECRET')!,
        });

        // 🔥 Cast có kiểm soát – CHUẨN NHẤT
        const vnpQuery = query as unknown as ReturnQueryFromVNPay;

        const isValid = vnpay.verifyReturnUrl(vnpQuery);

        return {
            isValid,
            responseCode: query.vnp_ResponseCode,
            orderId: query.vnp_TxnRef,
            amount: query.vnp_Amount,
        };
    }


    async handleIpnRaw(req: Request) {
        const rawQuery = req.originalUrl.split('?')[1] || '';

        // parse KHÔNG decode
        const vnp_Params = qs.parse(rawQuery, {
            decoder: (str) => str,
        }) as Record<string, string>;


        const secureHash = vnp_Params['vnp_SecureHash'];

        delete vnp_Params['vnp_SecureHash'];
        delete vnp_Params['vnp_SecureHashType'];

        /* =====================================================
         * 2️⃣ SORT + VERIFY CHECKSUM
         * ===================================================== */
        const sortedParams = Object.keys(vnp_Params)
            .sort()
            .reduce((acc, key) => {
                acc[key] = vnp_Params[key];
                return acc;
            }, {} as Record<string, string>);

        const signData = qs.stringify(sortedParams, { encode: false });

        const signed = crypto
            .createHmac(
                'sha512',
                this.configService.get<string>('VNP_HASHSECRET')!,
            )
            .update(Buffer.from(signData, 'utf-8'))
            .digest('hex');



        if (secureHash !== signed) {
            return { RspCode: '97', Message: 'Invalid Signature' };
        }

        /* =====================================================
         * 3️⃣ PARSE DATA
         * ===================================================== */
        const orderId = vnp_Params['vnp_TxnRef'];
        const amount = Number(vnp_Params['vnp_Amount']) / 100;
        const responseCode = vnp_Params['vnp_ResponseCode'];
        const transactionStatus = vnp_Params['vnp_TransactionStatus'];

        /* =====================================================
         * 4️⃣ FIND ORDER
         * ===================================================== */
        const order = await this.orderRepo.findOne({
            where: { orderId: Number(orderId) },
        });

        if (!order) {
            return { RspCode: '01', Message: 'Order not found' };
        }

        /* =====================================================
         * 5️⃣ CHECK AMOUNT
         * ===================================================== */
        if (Number(order.totalAmount) !== Number(amount)) {
            return { RspCode: '04', Message: 'Invalid amount' };
        }

        /* =====================================================
         * 6️⃣ ALREADY CONFIRMED
         * ===================================================== */
        if (order.paymentStatus === 'Paid') {
            return { RspCode: '02', Message: 'Order already confirmed' };
        }

        /* =====================================================
         * 7️⃣ UPDATE STATUS
         * ===================================================== */
        if (responseCode === '00' && transactionStatus === '00') {
            order.paymentStatus = 'Paid';
        } else {
            order.paymentStatus = 'Failed';
        }

        await this.orderRepo.save(order);

        /* =====================================================
         * 8️⃣ CONFIRM SUCCESS
         * ===================================================== */
        return { RspCode: '00', Message: 'Confirm Success' };
    }
}
