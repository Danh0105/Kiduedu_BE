import { IsString, IsOptional } from 'class-validator';

export class NotifyBillRequestDto {
    @IsString()
    msgId: string;

    @IsString()
    providerId: string;

    @IsString()
    transId: string;

    @IsString()
    transTime: string; // yyyyMMddHHmmss

    @IsString()
    transType: string;

    @IsOptional()
    @IsString()
    custCode?: string;

    @IsOptional()
    @IsString()
    sendBankId?: string;

    @IsOptional()
    @IsString()
    sendBranchId?: string;

    @IsOptional()
    @IsString()
    sendAcctId?: string;

    @IsOptional()
    @IsString()
    sendAcctName?: string;

    @IsOptional()
    @IsString()
    recvAcctId?: string;

    @IsOptional()
    @IsString()
    recvAcctName?: string;

    @IsOptional()
    @IsString()
    recvVirtualAcctId?: string;

    @IsOptional()
    @IsString()
    recvVirtualAcctName?: string;

    @IsString()
    amount: string;

    @IsOptional()
    @IsString()
    bankTransId?: string;

    @IsString()
    remark: string;

    @IsString()
    currencyCode: string;

    @IsString()
    signature: string;
}
