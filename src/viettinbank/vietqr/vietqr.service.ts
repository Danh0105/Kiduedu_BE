import axios from 'axios';
import { Injectable } from '@nestjs/common';
import { GenVietQrDto } from './gen-vietqr.dto';
import { signData, verifySignature } from './vietqr.crypto';
import { randomUUID } from 'crypto';
import { GenerateVietQrDto } from './generate-vietqr.dto';

@Injectable()
export class VietQrService {
    async generateQr(dto: GenVietQrDto) {
        try {

            dto.requestId = dto.requestId ?? randomUUID();
            dto.providerId = '9752';
            dto.merchantId = '9752';
            dto.channel = 'WEB';
            dto.version = '1.0.1';
            dto.language = 'vi';
            dto.clientIP = '160.250.132.143'
            dto.clientDt = new Date().toISOString();
            const signDataString =
                dto.requestId +
                dto.providerId +
                dto.merchantId +
                dto.clientDt +
                dto.data.accountNumber;

            dto.signature = signData(
                signDataString,
                process.env.VIETINBANK_PRIVATE_KEY_PATH!,
            );
            console.log(dto)
            const res = await axios.post(
                `${process.env.VIETINBANK_BASE_URL}`,
                dto,
                {
                    headers: {
                        'Content-Type': 'application/json',
                        'x-ibm-client-id': process.env.VIETINBANK_CLIENT_ID!,
                        'x-ibm-client-secret': process.env.VIETINBANK_CLIENT_SECRET!,
                    },
                    timeout: 15000,
                },
            );


            const responseData = res.data;

            const verifyData =
                responseData.requestId +
                responseData.providerId +
                responseData.merchantId +
                responseData.clientDt +
                responseData.status.statusCode;

            const isValid = verifySignature(
                verifyData,
                responseData.signature,
                process.env.VIETINBANK_PUBLIC_KEY_PATH!,
            );

            if (!isValid) {
                throw new Error('Invalid VietinBank signature');
            }
            console.log("responseData", responseData)
            return responseData;
        } catch (error) {

            throw error;
        }
    }
    async generateFromOrder(dto: GenerateVietQrDto) {
        const accountNumber = `${process.env.VTB_ACCOUNT}${dto.orderId}`;

        const vietQrDto: GenVietQrDto = {
            data: {
                accountNumber,
                amount: dto.amount,
                purposeOfTrans: dto.purpose,
            },
        };

        return this.generateQr(vietQrDto);
    }


}
