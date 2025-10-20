import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { CustomerServiceService } from './customer-service.service';
import { CustomerServiceEntity } from './customer-service.entity';

@Controller('customer-services')
export class CustomerServiceController {
    constructor(private readonly csService: CustomerServiceService) { }

    @Get()
    getAll(): Promise<CustomerServiceEntity[]> {
        return this.csService.findAll();
    }

    @Get(':id')
    getOne(@Param('id') id: string) {
        return this.csService.findOne(id);
    }

    @Post()
    create(@Body() data: Partial<CustomerServiceEntity>) {
        return this.csService.create(data);
    }

    @Put(':id')
    update(@Param('id') id: string, @Body() data: Partial<CustomerServiceEntity>) {
        return this.csService.update(id, data);
    }

    @Delete(':id')
    remove(@Param('id') id: string) {
        return this.csService.remove(id);
    }
}
