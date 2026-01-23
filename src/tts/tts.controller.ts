import { Controller, Post, Body, Res } from "@nestjs/common";
import type { Response } from "express";
import { TtsService } from "./tts.service";

@Controller("tts")
export class TtsController {
  constructor(private readonly ttsService: TtsService) { }

  @Post()
  async tts(@Body("text") text: string, @Res() res: Response) {
    const audio = await this.ttsService.speak(text);

    res.set({
      "Content-Type": "audio/mpeg",
      "Content-Length": audio.length,
      "Content-Disposition": "inline; filename=tts.mp3",
    });

    res.end(audio);
  }

}
