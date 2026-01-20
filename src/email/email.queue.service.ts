// src/email/email.queue.service.ts
import { Injectable } from '@nestjs/common';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';

@Injectable()
export class EmailQueueService {
    constructor(
        @InjectQueue('emailQueue') private emailQueue: Queue,
    ) { }

    async addVerifyEmailJob(email: string, token: string) {
        await this.emailQueue.add(
            'sendVerifyEmail',
            { email, token },
            {
                attempts: 5,
                backoff: 5000,
                removeOnComplete: true,
                removeOnFail: false,
            },
        );
    }
    async addOrderSuccessNotifyJob(order: any) {
        await this.emailQueue.add("sendOrderSuccessNotify", {
            orderId: order.orderId,
            total: order.totalAmount,
            userEmail: order.user.email,
        });
    }
    async addYepInvitationJob(data: {
        email: string;
        fullName: string;
        qrCode: string;
    }) {
        await this.emailQueue.add(
            'sendYepInvitation',
            data,
            {
                attempts: 5,
                backoff: 5000,
                removeOnComplete: true,
                removeOnFail: false,
            },
        );
    }

}
