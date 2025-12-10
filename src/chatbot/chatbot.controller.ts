import { Controller, Post, Body } from "@nestjs/common";
import { chatbotScript } from "./chatbot.script";

@Controller("chatbot")
export class ChatbotController {
    @Post("menu")
    handleMenu(@Body() body: { key: string }) {
        const key = body.key || "welcome";
        const node = chatbotScript[key];

        if (!node)
            return { text: "Xin lỗi, tôi chưa hiểu ý bạn!", options: [] };

        return node;
    }
}
