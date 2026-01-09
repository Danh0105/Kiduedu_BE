// src/vnpay/middleware/vnpay-ipn-whitelist.middleware.ts
import {
    Injectable,
    NestMiddleware,
    ForbiddenException,
    Logger,
} from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { VNPAY_IP_WHITELIST } from '../ipn-whitelist';

@Injectable()
export class VnpayIpnWhitelistMiddleware implements NestMiddleware {
    private readonly logger = new Logger('VNPAY-IPN');

    use(req: Request, res: Response, next: NextFunction) {
        // 🔑 Lấy IP thật (ưu tiên proxy/nginx)
        const ip =
            (req.headers['x-forwarded-for'] as string)?.split(',')[0]?.trim() ||
            req.socket.remoteAddress?.replace('::ffff:', '');

        const env =
            process.env.NODE_ENV === 'production' ? 'production' : 'sandbox';

        const whitelist = VNPAY_IP_WHITELIST[env];

        if (!ip || !whitelist.includes(ip)) {
            this.logger.warn({
                message: 'IP NOT WHITELISTED',
                ip,
                env,
                method: req.method,
                path: req.originalUrl,
                query: req.query, // GET → log query
            });

            throw new ForbiddenException('IP not allowed');
        }

        // ✅ IP hợp lệ
        this.logger.log({
            message: 'IPN ACCEPTED',
            ip,
            env,
            method: req.method,
            path: req.originalUrl,
        });

        next();
    }
}
