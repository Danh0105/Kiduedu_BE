import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChatbotNode } from './entities/chatbot-node.entity';
import { ChatbotOption } from './entities/chatbot-option.entity';
import { ChatbotService } from './chatbot.service';
import { ChatbotController } from './chatbot.controller';

@Module({
    imports: [TypeOrmModule.forFeature([ChatbotNode, ChatbotOption])],
    controllers: [ChatbotController],
    providers: [ChatbotService],
})
export class ChatbotModule { }
