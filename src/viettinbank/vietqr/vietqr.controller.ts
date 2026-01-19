import { Body, Controller, Post } from '@nestjs/common';
import { VietQrService } from './vietqr.service';
import { GenVietQrDto } from './gen-vietqr.dto';
import { GenerateVietQrDto } from './generate-vietqr.dto';

@Controller('vietqr')
export class VietQrController {
    constructor(private readonly service: VietQrService) { }

    @Post('generate')
    generate(@Body() dto: GenerateVietQrDto) {
        console.log("dto", dto)
        return this.service.generateFromOrder(dto);
    }


}
