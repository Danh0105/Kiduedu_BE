import {
    IsString,
    IsNumber,
    IsOptional,
    IsArray,
    ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

class PromotionInfoDto {
    @IsNumber()
    amount: number;

    @IsNumber()
    amountSponsor: number;

    @IsString()
    voucherId: string;

    @IsString()
    voucherType: string;

    @IsString()
    voucherName: string;

    @IsString()
    merchantRate: string;
}

export class MomoIpnDto {
    @IsString()
    partnerCode: string;

    @IsString()
    orderId: string;

    @IsString()
    requestId: string;

    @IsNumber()
    amount: number;

    @IsOptional()
    @IsString()
    storeId?: string;

    @IsString()
    orderInfo: string;

    @IsOptional()
    @IsString()
    partnerUserId?: string;

    @IsString()
    orderType: string; // momo_wallet

    @IsNumber()
    transId: number;

    @IsNumber()
    resultCode: number;

    @IsString()
    message: string;

    @IsString()
    payType: string;

    @IsNumber()
    responseTime: number;

    @IsString()
    extraData: string;

    @IsString()
    signature: string;

    @IsOptional()
    @IsString()
    paymentOption?: string;

    @IsOptional()
    @IsNumber()
    userFee?: number;

    @IsOptional()
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => PromotionInfoDto)
    promotionInfo?: PromotionInfoDto[];
}
