import {
    Controller,
    Get,
    Post,
    Patch,
    Delete,
    Param,
    Body,
    ParseIntPipe,
} from '@nestjs/common';
import { PrizesService } from './prizes.service';

@Controller('prizes')
export class PrizesController {
    constructor(private readonly prizesService: PrizesService) { }

    @Post()
    create(@Body() body) {
        return this.prizesService.create(body);
    }

    @Get()
    findAll() {
        return this.prizesService.findAll();
    }

    @Get(':id')
    findOne(@Param('id', ParseIntPipe) id: number) {
        return this.prizesService.findOne(id);
    }

    @Patch(':id')
    update(
        @Param('id', ParseIntPipe) id: number,
        @Body() body,
    ) {
        return this.prizesService.update(id, body);
    }

    @Delete(':id')
    remove(@Param('id', ParseIntPipe) id: number) {
        return this.prizesService.remove(id);
    }
}
