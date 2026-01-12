import { IsOptional, IsString } from 'class-validator';

export class GenVietQrDto {
    @IsOptional()
    @IsString()
    requestId?: string;

    @IsOptional()
    @IsString()
    merchantId?: string;

    @IsOptional()
    @IsString()
    providerId?: string;

    @IsOptional()
    @IsString()
    channel?: string;

    @IsOptional()
    @IsString()
    version?: string;

    @IsOptional()
    @IsString()
    clientDt?: string;

    @IsOptional()
    @IsString()
    language?: string;

    @IsOptional()
    @IsString()
    clientIP?: string;

    @IsOptional()
    data: {
        accountNumber: string;
        amount?: number;
        purposeOfTrans?: string;
    };

    // 🔥 BẮT BUỘC PHẢI CÓ
    @IsOptional()
    @IsString()
    signature?: string;
}
