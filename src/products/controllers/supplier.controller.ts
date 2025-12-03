import {
    Controller,
    Get,
    Post,
    Put,
    Delete,
    Param,
    Body,
} from '@nestjs/common';
import { SupplierService } from '../services/supplier.service';

@Controller('suppliers')
export class SupplierController {
    constructor(private service: SupplierService) { }

    /* =================== CREATE =================== */
    @Post()
    create(@Body() body: any) {
        return this.service.create(body);
    }

    /* =================== GET ALL =================== */
    @Get()
    findAll() {
        return this.service.findAll();
    }

    /* =================== GET ONE =================== */
    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.service.findOne(Number(id));
    }

    /* =================== UPDATE =================== */
    @Put(':id')
    update(@Param('id') id: string, @Body() body: any) {
        return this.service.update(Number(id), body);
    }

    /* =================== DELETE =================== */
    @Delete(':id')
    remove(@Param('id') id: string) {
        return this.service.remove(Number(id));
    }
}
