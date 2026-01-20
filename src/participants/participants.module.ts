import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Participant } from './participant.entity';
import { ParticipantsController } from './participants.controller';
import { ParticipantsService } from './participants.service';
import { EmailQueueModule } from 'src/email/email.queue.module';

@Module({
    imports: [TypeOrmModule.forFeature([Participant]), EmailQueueModule],
    controllers: [ParticipantsController],
    providers: [ParticipantsService],
})
export class ParticipantsModule { }
