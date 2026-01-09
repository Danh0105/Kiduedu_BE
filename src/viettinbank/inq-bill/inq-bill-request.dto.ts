import {
    IsString,
    IsObject,
    IsOptional,
    ValidateNested,
    IsIn,
} from 'class-validator';
import { Type } from 'class-transformer';

export class InqBillHeaderDto {
    @IsString()
    msgId: string;

    @IsIn(['1100'])
    msgType: string;

    @IsString()
    channelId: string;

    @IsString()
    gatewayId: string;

    @IsString()
    providerId: string;

    @IsString()
    merchantId: string;

    @IsString()
    productId: string;

    @IsString()
    timestamp: string; // MMddyyyyHHmmss

    @IsOptional()
    @IsString()
    username?: string;

    @IsString()
    signature: string;

    @IsOptional()
    @IsObject()
    additionalProperties?: Record<string, any>;
}

export class InqBillDataDto {
    @IsString()
    transId: string;

    @IsString()
    transTime: string;

    @IsString()
    custCode: string;

    @IsOptional()
    @IsObject()
    additionalProperties?: Record<string, any>;
}

export class InqBillRequestDto {
    @ValidateNested()
    @Type(() => InqBillHeaderDto)
    header: InqBillHeaderDto;

    @ValidateNested()
    @Type(() => InqBillDataDto)
    data: InqBillDataDto;

    @IsOptional()
    @IsObject()
    additionalProperties?: Record<string, any>;
}
