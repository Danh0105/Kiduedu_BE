import { Controller, Post, Body } from '@nestjs/common';
import { OpenaiService } from './openai.service';

@Controller('chat')
export class OpenaiController {
  constructor(private readonly openaiService: OpenaiService) { }

  @Post()
  async chat(@Body('message') message: string) {
    return { reply: await this.openaiService.chatWithGPT(message) };
  }
}
