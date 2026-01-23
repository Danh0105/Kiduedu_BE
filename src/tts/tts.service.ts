import axios from "axios";
import { Injectable } from "@nestjs/common";

@Injectable()
export class TtsService {
    private token?: string;
    private tokenExpire = 0;

    private async getToken() {
        if (this.token && Date.now() < this.tokenExpire) {
            return this.token;
        }

        const res = await axios.post(
            `https://${process.env.AZURE_SPEECH_REGION}.api.cognitive.microsoft.com/sts/v1.0/issueToken`,
            null,
            {
                headers: {
                    "Ocp-Apim-Subscription-Key":
                        process.env.AZURE_SPEECH_KEY!,
                },
            }
        );

        this.token = res.data;
        this.tokenExpire = Date.now() + 9 * 60 * 1000; // 9 phút

        return this.token;
    }

    async speak(text: string): Promise<Buffer> {
        const ssml = `
<speak version="1.0" xml:lang="vi-VN">
  <voice name="vi-VN-HoaiMyNeural">
    ${text}
  </voice>
</speak>`;

        const res = await axios.post(
            `https://${process.env.AZURE_SPEECH_REGION}.tts.speech.microsoft.com/cognitiveservices/v1`,
            ssml,
            {
                responseType: "arraybuffer",
                timeout: 10000,
                headers: {
                    "Ocp-Apim-Subscription-Key": process.env.AZURE_SPEECH_KEY!,
                    "Content-Type": "application/ssml+xml; charset=utf-8",
                    "X-Microsoft-OutputFormat":
                        "audio-16khz-32kbitrate-mono-mp3",
                    "User-Agent": "nestjs-tts",
                },
            }
        );

        return Buffer.from(res.data);
    }

}
