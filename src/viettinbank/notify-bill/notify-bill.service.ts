import { Injectable } from '@nestjs/common';
import { NotifyBillRequestDto } from './notify-bill-request.dto';
import { NotifyBillResponseDto } from './notify-bill-response.dto';
import { CryptoKeyService } from '../crypto/crypto-key.service';
import { InjectRepository } from '@nestjs/typeorm';
import { Order } from 'src/orders/entities/order.entity';
import { Repository } from 'typeorm';

@Injectable()
export class NotifyBillService {
    constructor(
        private readonly crypto: CryptoKeyService,
        @InjectRepository(Order)
        private readonly orderRepo: Repository<Order>,
    ) {

    }

    async handleNotify(
        dto: NotifyBillRequestDto,
    ): Promise<NotifyBillResponseDto> {

        const verifyData =
            dto.transId +
            dto.transTime +
            (dto.custCode ?? '') +
            dto.amount +
            (dto.bankTransId ?? '') +
            dto.remark;

        if (!this.crypto.verify(verifyData, dto.signature)) {
            return this.buildResponse(dto, '01', 'Sai chữ ký');
        }

        const PREFIX = '1KDEPFZ';
        if (!dto.custCode?.startsWith(PREFIX)) {
            return this.buildResponse(dto, '04', 'Sai custCode');
        }

        const orderId = Number(dto.custCode.slice(PREFIX.length));
        const order = await this.orderRepo.findOne({ where: { orderId } });

        if (!order) {
            return this.buildResponse(dto, '03', 'Order không tồn tại');
        }

        // chống trùng bankTransId
        const existed = await this.orderRepo.findOne({
            where: { bankTransId: dto.bankTransId },
        });
        if (existed) {
            return this.buildResponse(dto, '00', 'Already processed');
        }

        // check amount
        if (Number(dto.amount) !== Number(order.totalAmount)) {
            return this.buildResponse(dto, '05', 'Sai so tien');
        }

        if (order.paymentStatus === 'Paid') {
            return this.buildResponse(dto, '00', 'Already processed');
        }

        order.paymentStatus = 'Paid';
        if (!dto.bankTransId) {
            return this.buildResponse(dto, '06', 'Thieu bankTransId');
        }
        order.bankTransId = dto.bankTransId;
        await this.orderRepo.save(order);

        return this.buildResponse(dto, '00', 'Thanh cong');
    }

    private buildResponse(
        dto: NotifyBillRequestDto,
        errorCode: string,
        errorDesc: string,
    ): NotifyBillResponseDto {
        /**
         * Chuỗi ký RESPONSE:
         * transId + errorCode + errorDesc
         */
        const signData =
            dto.transId +
            errorCode +
            errorDesc;

        return {
            transId: dto.transId,
            providerId: dto.providerId,
            errorCode,
            errorDesc,
            signature: this.crypto.sign(signData),
        };
    }
}
