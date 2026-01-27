import { Controller, Post, Get, Body, UseInterceptors, UploadedFile, BadRequestException, Param, Query, Res, Patch } from '@nestjs/common';
import { ParticipantsService } from './participants.service';
import { FileInterceptor } from '@nestjs/platform-express';
import * as XLSX from 'xlsx';
import { diskStorage } from 'multer';
import { extname } from 'path';
import type { Response } from "express";
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Participant } from './participant.entity';
@Controller('participants')
export class ParticipantsController {
    constructor(
        private readonly service: ParticipantsService,
        @InjectRepository(Participant)
        private readonly repo: Repository<Participant>,
    ) { }
    @Post()
    create(@Body() body: any) {
        return this.service.createOne(body);
    }


    @Get()
    getRemaining() {
        return this.service.getRemaining();
    }

    @Post('spin')
    spin() {
        return this.service.spin();
    }

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
    @Patch(':id/winner')
    async setWinner(@Param('id') id: number) {
        await this.service.markAsWinner(id);
        return { success: true };
    }

    @Post('checkin')
    async checkin(@Body('qrCode') qrCode: string) {
        return this.service.checkInByQr(qrCode);
    }
    @Post(':id/send-invite')
    async sendInviteEmail(@Param('id') id: number) {
        return this.service.sendInviteEmail(id);
    }
    @Post('send-invite-all')
    async sendInviteToAll() {
        return this.service.sendInviteEmailToAll();
    }
    @Post('send-invite-all-ichi')
    async sendInviteToAllIchi() {
        return this.service.sendInviteEmailToAllIchi();
    }
    @Post('send-invite-all-gate')
    async sendInviteToAllGate() {
        return this.service.sendInviteEmailToAllGate();
    }
    @Get('checked-in')
    getCheckedIn() {
        return this.service.getCheckedIn();
    }
    @Post('checkin/avatar/:id')
    @UseInterceptors(
        FileInterceptor('file', {
            storage: diskStorage({
                destination: './public/uploads/checkin',
                filename: (req, file, cb) => {
                    const ext = extname(file.originalname);
                    const filename = `checkin_${Date.now()}${ext}`;
                    cb(null, filename);
                },
            }),
            fileFilter: (req, file, cb) => {
                if (!file.mimetype.startsWith('image/')) {
                    return cb(new BadRequestException('Chỉ cho phép ảnh'), false);
                }
                cb(null, true);
            },
        }),
    )
    async uploadCheckinAvatar(
        @Param('id') id: number,
        @UploadedFile() file: Express.Multer.File,
    ) {
        const participant = await this.repo.findOneBy({ id });

        if (!participant) {
            throw new BadRequestException('Không tìm thấy người tham gia');
        }

        participant.avatar = `/uploads/checkin/${file.filename}`;
        await this.repo.save(participant);

        return {
            message: 'Upload ảnh thành công',
            avatar: participant.avatar,
        };
    }

}
