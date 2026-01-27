import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Participant } from './participant.entity';
import { ParticipantsController } from './participants.controller';
import { ParticipantsService } from './participants.service';
import { EmailQueueModule } from 'src/email/email.queue.module';
import { CheckinController } from './checkin.controller';

@Module({
    imports: [TypeOrmModule.forFeature([Participant]), EmailQueueModule],
    controllers: [ParticipantsController, CheckinController],
    providers: [ParticipantsService],
})
export class ParticipantsModule { }
