import { Controller, Get, Post, Body, Param, Patch, Delete, UploadedFile, UseInterceptors } from '@nestjs/common';
import { BannerService } from './banner.service';
import { CreateBannerDto } from './dto/create-banner.dto';
import { UpdateBannerDto } from './dto/update-banner.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';

@Controller('banners')
export class BannerController {

    constructor(private readonly service: BannerService) { }

    @Post()
    create(@Body() dto: CreateBannerDto) {
        return this.service.create(dto);
    }

    @Get()
    findAll() {
        return this.service.findAll();
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.service.findOne(+id);
    }

    @Patch(':id')
    @UseInterceptors(FileInterceptor('image', {
        storage: diskStorage({
            destination: './public/uploads',
            filename: (req, file, cb) => {
                const unique = Date.now() + '-' + file.originalname;
                cb(null, unique);
            }
        })
    }))
    update(
        @Param('id') id: number,
        @Body() dto: UpdateBannerDto,
        @UploadedFile() file: Express.Multer.File,
    ) {
        return this.service.update(+id, dto, file);
    }


    @Delete(':id')
    remove(@Param('id') id: string) {
        return this.service.remove(+id);
    }
}
