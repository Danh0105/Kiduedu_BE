import {
    Controller,
    Get,
    Post,
    Put,
    Delete,
    Param,
    Body,
    ParseIntPipe,
} from '@nestjs/common';
import { ChatbotService } from './chatbot.service';
import { CreateNodeDto } from './dto/create-node.dto';
import { UpdateNodeDto } from './dto/update-node.dto';
import { CreateOptionDto } from './dto/create-option.dto';
import { UpdateOptionDto } from './dto/update-option.dto';

@Controller('chatbot')
export class ChatbotController {
    constructor(private readonly chatbotService: ChatbotService) { }

    /* ================= NODE ================= */

    @Get('nodes')
    getAllNodes() {
        return this.chatbotService.findAllNodes();
    }

    @Get('nodes/:key')
    getNodeByKey(@Param('key') key: string) {
        return this.chatbotService.findNodeByKey(key);
    }

    @Post('nodes')
    createNode(@Body() dto: CreateNodeDto) {
        return this.chatbotService.createNode(dto);
    }

    @Put('nodes/:id')
    updateNode(
        @Param('id', ParseIntPipe) id: number,
        @Body() dto: UpdateNodeDto,
    ) {
        return this.chatbotService.updateNode(id, dto);
    }

    @Delete('nodes/:id')
    deleteNode(@Param('id', ParseIntPipe) id: number) {
        return this.chatbotService.deleteNode(id);
    }

    /* ================= OPTION ================= */

    @Post('options')
    createOption(@Body() dto: CreateOptionDto) {
        return this.chatbotService.createOption(dto);
    }

    @Put('options/:id')
    updateOption(
        @Param('id', ParseIntPipe) id: number,
        @Body() dto: UpdateOptionDto,
    ) {
        return this.chatbotService.updateOption(id, dto);
    }

    @Post('menu')
    async menu(@Body() body: { key?: string }) {
        const key = body.key || null;

        let node;
        if (!key) {
            node = await this.chatbotService.findStartNode();
        } else {
            node = await this.chatbotService.findNodeByKey(key);
        }

        return {
            text: node.content,
            options: node.options.map(o => ({
                label: o.label,
                nextKey: o.nextNodeKey,
            })),
        };
    }


    @Delete('options/:id')
    deleteOption(@Param('id', ParseIntPipe) id: number) {
        return this.chatbotService.deleteOption(id);
    }
}
