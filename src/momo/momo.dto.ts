export class MomoIpnDto {
    partnerCode: string;
    orderId: string;
    requestId: string;
    amount: number;
    orderInfo: string;
    orderType: string;
    transId: number;
    resultCode: number;
    message: string;
    payType: string;
    responseTime: number;
    extraData: string;
    signature: string;

    // optional
    storeId?: string;
    partnerUserId?: string;
    paymentOption?: string;
    userFee?: number;
    promotionInfo?: any[];
}
