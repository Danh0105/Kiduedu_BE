import { Type } from 'class-transformer';
import { IsNotEmpty, IsOptional, IsString, ValidateNested } from 'class-validator';

export class InqBillHeaderDto {
    @IsString()
    msgId: string;

    @IsString()
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
    timestamp: string;

    @IsString()
    recordNum: string;

    @IsString()
    version: string;

    @IsString()
    language: string;

    @IsString()
    signature: string;
}

export class InqBillDataDto {
    @IsString()
    transId: string;

    @IsOptional()
    @IsString()
    channelId?: string;

    @IsString()
    transTime: string;

    @IsString()
    custCode: string;
}

export class InqBillRequestDto {
    @ValidateNested()
    @Type(() => InqBillHeaderDto)
    header: InqBillHeaderDto;

    @ValidateNested()
    @Type(() => InqBillDataDto)
    data: InqBillDataDto;
}
