import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { PolicyService } from './policy.service';
import { Policy } from './policy.entity';

@Controller('policies')
export class PolicyController {
    constructor(private readonly policyService: PolicyService) { }

    @Get()
    getAll(): Promise<Policy[]> {
        return this.policyService.findAll();
    }

    @Get(':id')
    getOne(@Param('id') id: string) {
        return this.policyService.findOne(id);
    }

    @Post()
    create(@Body() data: Partial<Policy>) {
        return this.policyService.create(data);
    }

    @Put(':id')
    update(@Param('id') id: string, @Body() data: Partial<Policy>) {
        return this.policyService.update(id, data);
    }

    @Delete(':id')
    remove(@Param('id') id: string) {
        return this.policyService.remove(id);
    }
}
