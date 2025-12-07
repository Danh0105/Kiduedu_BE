import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bullmq';
import { ConfigService } from '@nestjs/config';
import { EmailQueueService } from './email.queue.service';
import { EmailQueueProcessor } from './email.queue.processor';
import { SettingsModule } from 'src/settings/settings.module';

@Module({
    imports: [
        SettingsModule,
        BullModule.registerQueueAsync({
            name: 'emailQueue',
            useFactory: (config: ConfigService) => ({
                connection: {
                    host: config.get('REDIS_HOST'),
                    port: config.get<number>('REDIS_PORT'),
                },
            }),
            inject: [ConfigService],
        }),
    ],
    providers: [EmailQueueService, EmailQueueProcessor],
    exports: [EmailQueueService],
})
export class EmailQueueModule { }
