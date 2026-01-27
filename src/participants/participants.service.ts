import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Participant } from './participant.entity';
import { v4 as uuidv4 } from 'uuid';
import { EmailQueueService } from 'src/email/email.queue.service';
@Injectable()
export class ParticipantsService {
    constructor(
        @InjectRepository(Participant)
        private readonly repo: Repository<Participant>,
        private readonly emailQueueService: EmailQueueService,
    ) { }
    async createOne(dto: any) {

        console.log(dto);


        const participant = this.repo.create({
            fullName: dto.fullName.trim(),
            position: dto.position ? dto.position.trim() : null,
            qrCode: uuidv4(),
            guestType: "khachmoi"
        });

        await this.repo.save(participant);

        // 👉 TRẢ QR + DATA
        return {
            id: participant.id,
            fullName: participant.fullName,
            qrCode: participant.qrCode,
        };
    }



    // Danh sách còn trong vòng quay
    async getRemaining() {
        return this.repo.find({
            where: { isWinner: false },
            order: { id: 'ASC' },
        });
    }

    // RANDOM NGƯỜI TRÚNG
    async spin() {
        return this.repo.manager.transaction(async manager => {
            const participants = await manager.find(Participant, {
                where: { isWinner: false },
                lock: { mode: 'pessimistic_write' },
            });

            if (participants.length === 0) {
                throw new BadRequestException('Không còn người để quay');
            }

            const winner =
                participants[Math.floor(Math.random() * participants.length)];

            winner.isWinner = true;
            await manager.save(winner);

            const remaining = await manager.find(Participant, {
                where: { isWinner: false },
            });

            return { winner, remaining };
        });
    }


    // Reset (admin)
    async reset() {
        await this.repo.update({}, { isWinner: false });
        return this.getRemaining();
    }

    async importFromFile(rows: any[]) {
        const entities: Participant[] = [];

        for (const row of rows) {
            if (!row.fullName || !row.email) continue;

            const email = row.email.toString().trim().toLowerCase();

            const exists = await this.repo.findOne({ where: { email } });
            if (exists) continue;

            entities.push(
                this.repo.create({
                    fullName: row.fullName.trim(),
                    email,
                    qrCode: uuidv4(),
                    department: row.department ? row.department.toString().trim() : null,
                    position: row.position ? row.position.toString().trim() : null,
                    guestType: row.guestType ? row.guestType.toString().trim() : null,
                }),
            );
        }

        if (!entities.length) {
            throw new BadRequestException('Không có dữ liệu hợp lệ');
        }

        await this.repo.save(entities);
        return this.getRemaining();
    }
    async checkInByQr(qrCode: string) {
        const participant = await this.repo.findOne({
            where: { qrCode },
        });

        if (!participant) {
            throw new BadRequestException('QR không hợp lệ');
        }

        if (participant.isCheckedIn) {
            throw new BadRequestException('Đã check-in trước đó');
        }

        participant.isCheckedIn = true;
        participant.checkedInAt = new Date();

        await this.repo.save(participant);
        return participant;
    }

    async sendInviteEmail(participantId: number) {
        const participant = await this.repo.findOne({
            where: { id: participantId },
        });

        if (!participant) {
            throw new BadRequestException('Không tìm thấy khách');
        }

        await this.emailQueueService.addYepInvitationJob({
            email: participant.email,
            fullName: participant.fullName,
            qrCode: participant.qrCode,
        });

        return { message: 'Đã đưa email vào queue gửi' };
    }

    async sendInviteEmailToAll() {
        const participants = await this.repo.find();

        for (const p of participants) {
            await this.emailQueueService.addYepInvitationJob({
                email: p.email,
                fullName: p.fullName,
                qrCode: p.qrCode,
            });
        }

        return {
            sent: participants.length,
        };
    }



    async sendInviteEmailToAllIchi() {
        const participants = await this.repo.find({
            where: {
                guestType: "ichiskill",
            },
        });

        for (const p of participants) {
            await this.emailQueueService.addYepInvitationJob({
                email: p.email,
                fullName: p.fullName,
                qrCode: p.qrCode,
            });
        }

        return {
            sent: participants.length,
        };
    }
    async sendInviteEmailToAllGate() {
        const participants = await this.repo.find({
            where: {
                guestType: "gate",
            },
        });

        for (const p of participants) {
            await this.emailQueueService.addYepInvitationJob({
                email: p.email,
                fullName: p.fullName,
                qrCode: p.qrCode,
            });
        }

        return {
            sent: participants.length,
        };
    }
    async getCheckedIn() {
        return this.repo.find({
            where: { isCheckedIn: true },
            order: { checkedInAt: 'DESC' },
        });
    }
}
