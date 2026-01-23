import { Injectable } from "@nestjs/common";
import * as sdk from "microsoft-cognitiveservices-speech-sdk";

@Injectable()
export class TtsService {
    private speechConfig: sdk.SpeechConfig;

    constructor() {
        this.speechConfig = sdk.SpeechConfig.fromSubscription(
            process.env.AZURE_SPEECH_KEY!,
            process.env.AZURE_SPEECH_REGION!
        );

        this.speechConfig.speechSynthesisVoiceName =
            "vi-VN-HoaiMyNeural";

        this.speechConfig.speechSynthesisOutputFormat =
            sdk.SpeechSynthesisOutputFormat.Audio16Khz32KBitRateMonoMp3;
    }

    speak(text: string): Promise<Buffer> {
        return new Promise((resolve, reject) => {
            const audioStream = sdk.AudioOutputStream.createPullStream();
            const audioConfig = sdk.AudioConfig.fromStreamOutput(audioStream);

            const synthesizer = new sdk.SpeechSynthesizer(
                this.speechConfig,
                audioConfig
            );

            synthesizer.speakTextAsync(
                text,
                result => {
                    synthesizer.close();

                    if (result.reason === sdk.ResultReason.SynthesizingAudioCompleted) {
                        resolve(Buffer.from(result.audioData));
                    } else {
                        reject(result.errorDetails);
                    }
                },
                err => {
                    synthesizer.close();
                    reject(err);
                }
            );
        });
    }
}
