import { Controller, Post, Get, Body, UseInterceptors, UploadedFile, BadRequestException } from '@nestjs/common';
import { ParticipantsService } from './participants.service';
import { FileInterceptor } from '@nestjs/platform-express';
import * as XLSX from 'xlsx';
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
    @Post('import-file')
    @UseInterceptors(FileInterceptor('file'))
    async importFromFile(@UploadedFile() file: Express.Multer.File) {
        if (!file) {
            throw new BadRequestException('Không có file upload');
        }

        const workbook = XLSX.read(file.buffer, { type: 'buffer' });
        const sheet = workbook.Sheets[workbook.SheetNames[0]];

        const rows: any[] = XLSX.utils.sheet_to_json(sheet);

        if (!rows.length) {
            throw new BadRequestException('File rỗng');
        }

        return this.service.importFromFile(rows);
    }

    @Post('checkin')
    async checkin(@Body('qrCode') qrCode: string) {
        return this.service.checkInByQr(qrCode);
    }

    @Post('send-invite-all')
    async sendInviteToAll() {
        return this.service.sendInviteEmailToAll();
    }
}
