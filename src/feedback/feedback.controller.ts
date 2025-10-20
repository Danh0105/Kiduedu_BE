import { Controller, Get, Post, Body } from '@nestjs/common';
import { FeedbackService } from './feedback.service';
import { IsEmail, IsNotEmpty, Length } from 'class-validator';

class CreateFeedbackDto {
    @IsNotEmpty()
    @Length(2, 100)
    name: string;

    @IsEmail()
    email: string;

    @IsNotEmpty()
    @Length(5, 1000)
    message: string;
}

@Controller('feedback')
export class FeedbackController {
    constructor(private readonly feedbackService: FeedbackService) { }

    @Get()
    getAll() {
        return this.feedbackService.findAll();
    }

    @Post()
    async create(@Body() data: CreateFeedbackDto) {
        const feedback = await this.feedbackService.create(data);
        return {
            message: 'Cảm ơn bạn đã gửi góp ý!',
            feedback,
        };
    }
}
