import { Injectable } from '@nestjs/common';
import { NotifyBillRequestDto } from './notify-bill-request.dto';
import { NotifyBillResponseDto } from './notify-bill-response.dto';
import { CryptoKeyService } from '../crypto/crypto-key.service';

@Injectable()
export class NotifyBillService {
    constructor(private readonly crypto: CryptoKeyService) { }

    handleNotify(dto: NotifyBillRequestDto): NotifyBillResponseDto {
        const verifyData =
            dto.transId +
            dto.transTime +
            (dto.custCode ?? '') +
            dto.amount +
            (dto.bankTransId ?? '') +
            dto.remark;

        const valid = this.crypto.verify(
            verifyData,
            dto.signature,
        );

        if (!valid) {
            return this.buildResponse(
                dto,
                '01',
                'Sai chữ ký',
            );
        }
        const isSuccess = true;

        if (!isSuccess) {
            return this.buildResponse(
                dto,
                '02',
                'Xử lý giao dịch thất bại',
            );
        }

        /* ========= 3. TRẢ RESPONSE SUCCESS ========= */
        return this.buildResponse(
            dto,
            '00',
            'Thanh cong',
        );
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
