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
                host: '127.0.0.1',
                port: 6379,
            },
        }),
    ],
    providers: [EmailQueueService, EmailQueueProcessor],
    exports: [EmailQueueService],
})
export class EmailQueueModule { }
