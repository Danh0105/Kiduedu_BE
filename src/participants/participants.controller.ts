import { Controller, Post, Get, Body } from '@nestjs/common';
import { ParticipantsService } from './participants.service';

@Controller('participants')
export class ParticipantsController {
    constructor(private readonly service: ParticipantsService) { }

    // FE nạp danh sách
    @Post('import')
    import(@Body() body) {
        return this.service.import(body);
    }

    // FE lấy danh sách hiển thị vòng quay
    @Get()
    getRemaining() {
        return this.service.getRemaining();
    }

    // FE bấm XOAY
    @Post('spin')
    spin() {
        return this.service.spin();
    }

    // Reset vòng quay (admin)
    @Post('reset')
    reset() {
        return this.service.reset();
    }
}
