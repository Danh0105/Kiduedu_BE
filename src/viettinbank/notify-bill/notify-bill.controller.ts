import { Body, Controller, Post } from '@nestjs/common';
import { NotifyBillService } from './notify-bill.service';
import { NotifyBillRequestDto } from './notify-bill-request.dto';

@Controller('api/v1')
export class NotifyBillController {
    constructor(private readonly service: NotifyBillService) { }

    @Post('notify-bill')
    notify(@Body() dto: NotifyBillRequestDto) {
        return this.service.handleNotify(dto);
    }
}
