import { Controller, Post, Body, Get, Query, Res, Req } from '@nestjs/common';
import { VnpayService } from './vnpay.service';
import { ConfigService } from '@nestjs/config';
import type { Request, Response } from 'express';

@Controller('vnpay')
export class VnpayController {
    constructor(
        private readonly vnpayService: VnpayService,
        private readonly configService: ConfigService,
    ) { }

    // 1️⃣ TẠO LINK THANH TOÁN
    @Post('create-payment')
    async create(@Body() body: any) {
        return this.vnpayService.createPaymentUrl(body);
    }

    // 2️⃣ RETURN URL – REDIRECT USER (UX)
    @Get('return')
    vnpayReturn(
        @Query() query: Record<string, string>,
        @Res() res: Response,
    ) {
        const result = this.vnpayService.verifyReturn(query);

        const frontendUrl = this.configService.get<string>('FRONTEND_URL');
        if (!frontendUrl) {
            throw new Error('FRONTEND_URL is not configured');
        }

        const success = result.isValid && result.responseCode === '00';

        const redirectUrl = `${frontendUrl}/payment-result?orderId=${result.orderId}&resultCode=${success ? '0' : '1'
            }`;
        return res.redirect(302, redirectUrl);
    }

    @Get('ipn')
    async handleIpn(@Req() req: Request, @Res() res: Response) {
        const result = await this.vnpayService.handleIpnRaw(req);
        return res.status(200).json(result);
    }

}
