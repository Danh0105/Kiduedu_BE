import { BadRequestException, Injectable } from '@nestjs/common';
import { InqBillRequestDto } from './inq-bill-request.dto';
import { InqBillResponseDto } from './inq-bill-response.dto';
import { CryptoKeyService } from '../crypto/crypto-key.service';

@Injectable()
export class InqBillService {
    constructor(private readonly crypto: CryptoKeyService) { }

    private now(): string {
        const d = new Date();
        const pad = (n: number) => n.toString().padStart(2, '0');
        return (
            d.getFullYear().toString() +
            pad(d.getMonth() + 1) +
            pad(d.getDate()) +
            pad(d.getHours()) +
            pad(d.getMinutes()) +
            pad(d.getSeconds())
        );
    }

    private n(v: any): string {
        return v === null || v === undefined ? '' : String(v);
    }

    handleInquiry(dto: InqBillRequestDto): InqBillResponseDto {
        const header = dto?.header;
        const data = dto?.data;

        // ❗ KHÔNG THROW
        if (!header || !data) {
            return this.buildError(
                {
                    header: header ?? {
                        msgId: '',
                        msgType: '1110',
                        channelId: '',
                        providerId: '',
                        merchantId: '',
                        productId: '',
                    } as any,
                    data: data ?? {} as any,
                },
                '99',
                'Sai cấu trúc dữ liệu',
            );
        }

        if (!data.transId || !data.transTime || !data.custCode) {
            return this.buildError(dto, '99', 'Thiếu dữ liệu bắt buộc');
        }

        const verifyString =
            this.n(data.transId) +
            this.n(data.transTime) +
            this.n(data.custCode);
        console.log('VERIFY_STRING_RAW=', JSON.stringify(verifyString));
        console.log('SIGNATURE_RAW=', header.signature);
        console.log(
            'SIGNATURE_CLEAN=',
            header.signature.replace(/\s+/g, ''),
        );

        if (!this.crypto.verify(verifyString, header.signature)) {
            return this.buildError(dto, '01', 'Sai chữ ký');
        }

        if (data.custCode !== process.env.VTB_ACCOUNT) {
            return this.buildError(dto, '02', 'Không tìm thấy hóa đơn');
        }

        const amount = '648000';
        const details = {
            transId: data.transId,
            transTime: data.transTime,
            custCode: data.custCode,
            custName: `TRANVANA_${amount}VND`,
            billId: null,
            amount,
            amountMin: null,
            preseve1: null,
            preseve2: null,
            preseve3: null,
        };

        const errors = {
            errorCode: '00',
            errorDesc: 'Xử lý thành công',
        };

        /* ===== SIGN RESPONSE (THEO SPEC) ===== */
        const signData =
            this.n(details.transId) +
            this.n(details.transTime) +
            this.n(details.custCode) +
            this.n(details.custName) +
            this.n(details.billId) +
            this.n(details.amount) +
            this.n(errors.errorCode);

        return {
            header: {
                msgId: header.msgId,
                msgType: '1110',
                channelId: header.channelId,
                providerId: header.providerId,
                merchantId: header.merchantId,
                productId: header.productId,
                timestamp: this.now(),
                signature: this.crypto.sign(signData),
            },
            data: {
                errors,
                details,
            },
        };
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
            this.n(details.transId) +
            this.n(details.transTime) +
            this.n(details.custCode) +
            this.n(details.custName) +
            this.n(details.billId) +
            this.n(details.amount) +
            this.n(errorCode);

        return {
            header: {
                msgId: header.msgId,
                msgType: '1110',
                channelId: header.channelId,
                providerId: header.providerId,
                merchantId: header.merchantId,
                productId: header.productId,
                timestamp: this.now(),
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
