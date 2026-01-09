import { Injectable } from '@nestjs/common';
import { InqBillRequestDto } from './inq-bill-request.dto';
import { InqBillResponseDto } from './inq-bill-response.dto';
import { CryptoKeyService } from '../crypto/crypto-key.service';

@Injectable()
export class InqBillService {
    constructor(private readonly crypto: CryptoKeyService) { }

    handleInquiry(dto: InqBillRequestDto): InqBillResponseDto {
        const { header, data } = dto;


        const verifyString =
            data.transId +
            data.transTime +
            data.custCode;

        const valid = this.crypto.verify(
            verifyString,
            header.signature,
        );

        if (!valid) {
            return this.buildError(dto, '01', 'Sai chữ ký');
        }

        if (data.custCode !== '8CAP250730152800001') {
            return this.buildError(dto, '02', 'Không tìm thấy hóa đơn');
        }

        const bill = {
            transId: data.transId,
            transTime: data.transTime,
            custCode: data.custCode,
            custName: 'TranVanA_50000VND',
            billId: null,
            amount: '648000',
            amountMin: null,
            preseve1: null,
            preseve2: null,
            preseve3: null,
        };

        const response: InqBillResponseDto = {
            header: {
                msgId: header.msgId,
                msgType: '1110',
                channelId: header.channelId,
                providerId: header.providerId,
                merchantId: header.merchantId,
                productId: header.productId,
                timestamp: header.timestamp,
                signature: '',
            },
            data: {
                errors: {
                    errorCode: '00',
                    errorDesc: 'Xử lý thành công',
                },
                details: bill,
            },
        };
        const signResponseData =
            bill.transId +
            bill.transTime +
            bill.custCode +
            bill.custName +
            (bill.billId ?? '') +
            bill.amount +
            response.data.errors.errorCode;

        response.header.signature =
            this.crypto.sign(signResponseData);

        return response;
    }

    private buildError(
        dto: InqBillRequestDto,
        errorCode: string,
        errorDesc: string,
    ): InqBillResponseDto {
        const { header, data } = dto;

        const details = {
            transId: data.transId,
            transTime: data.transTime,
            custCode: data.custCode,
            custName: '',
            billId: null,
            amount: '0',
            amountMin: null,
            preseve1: null,
            preseve2: null,
            preseve3: null,
        };

        const signData =
            details.transId +
            details.transTime +
            details.custCode +
            details.custName +
            (details.billId ?? '') +
            details.amount +
            errorCode;

        return {
            header: {
                msgId: header.msgId,
                msgType: '1110',
                channelId: header.channelId,
                providerId: header.providerId,
                merchantId: header.merchantId,
                productId: header.productId,
                timestamp: header.timestamp,
                signature: this.crypto.sign(signData),
            },
            data: {
                errors: {
                    errorCode,
                    errorDesc,
                },
                details,
            },
        };
    }

}
