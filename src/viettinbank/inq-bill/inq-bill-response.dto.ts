export class InqBillResponseDto {
    header: {
        msgId: string;
        msgType: string;
        channelId: string;
        providerId: string;
        merchantId: string;
        productId: string;
        timestamp: string;
        signature: string;
    };
    data: {
        errors: {
            errorCode: string;
            errorDesc: string;
        };
        details: {
            transId: string;
            transTime: string;
            custCode: string;
            custName: string;
            billId: string | null;
            amount: string;
            amountMin: string | null;
            preseve1: string | null;
            preseve2: string | null;
            preseve3: string | null;
        };
    };
}
