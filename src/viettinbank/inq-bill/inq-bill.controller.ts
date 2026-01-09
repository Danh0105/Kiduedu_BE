import { Body, Controller, Post } from '@nestjs/common';
import { InqBillService } from './inq-bill.service';
import { InqBillRequestDto } from './inq-bill-request.dto';

@Controller('/vpg/collection/api/v1')
export class InqBillController {
    constructor(private readonly service: InqBillService) { }

    @Post('inq-bill')
    inqBill(@Body() dto: InqBillRequestDto) {
        return this.service.handleInquiry(dto);
    }
}
