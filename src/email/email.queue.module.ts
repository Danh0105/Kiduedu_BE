// src/email/email.queue.module.ts
import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bullmq';
import { EmailQueueService } from './email.queue.service';
import { EmailQueueProcessor } from './email.queue.processor';
import { SettingsModule } from 'src/settings/settings.module';

@Module({
    imports: [
        SettingsModule,
        BullModule.registerQueue({
            name: 'emailQueue',
            connection: {
                host: process.env.REDIS_HOST,
                port: Number(process.env.REDIS_PORT),
            },
        }),
    ],
    providers: [EmailQueueService, EmailQueueProcessor],
    exports: [EmailQueueService],
})
export class EmailQueueModule { }
