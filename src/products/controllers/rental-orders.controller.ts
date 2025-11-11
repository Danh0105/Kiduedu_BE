// src/products/controllers/rental-orders.controller.ts
import {
    Controller, Get, Post, Patch, Delete, Param, Body, Query, ParseIntPipe, UsePipes, ValidationPipe,
} from '@nestjs/common';
import { RentalOrdersService } from '../services/rental-orders.service';
import { CreateRentalOrderDto } from '../dto/create-rental-order.dto';
import { UpdateRentalOrderDto } from '../dto/update-rental-order.dto';
import { ListRentalOrdersQueryDto } from '../dto/list-rental-orders-query.dto';

@UsePipes(new ValidationPipe({ whitelist: true, transform: true }))
@Controller('rental-orders')
export class RentalOrdersController {
    constructor(private readonly service: RentalOrdersService) { }

    @Post()
    create(@Body() dto: CreateRentalOrderDto) {
        return this.service.create(dto);
    }

    @Get()
    findAll(@Query() q: ListRentalOrdersQueryDto) {
        const page = q.page ?? 1;
        const limit = q.limit ?? 20;

        return this.service.findAll({
            page,
            limit,
            userId: q.userId,
            status: q.status,
            withItems: !!q.withItems,
            withUser: !!q.withUser,
            createdFrom: q.createdFrom,
            createdTo: q.createdTo,
        });
    }

    @Get(':id')
    findOne(
        @Param('id', ParseIntPipe) id: number,
        @Query() q: { withItems?: any; withUser?: any }, // hoặc dùng DTO riêng ở mục 4
    ) {
        // khi dùng ValidationPipe global + DTO riêng, có thể bỏ ép kiểu thủ công này
        const withItems = q?.withItems === true || q?.withItems === 'true' || q?.withItems === '1';
        const withUser = q?.withUser === true || q?.withUser === 'true' || q?.withUser === '1';

        return this.service.findOne(id, {
            withItems,
            withUser,
        });
    }

    @Patch(':id')
    update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateRentalOrderDto) {
        return this.service.update(id, dto);
    }

    @Delete(':id')
    remove(@Param('id', ParseIntPipe) id: number) {
        return this.service.remove(id);
    }

    @Get(':id/items')
    listItems(@Param('id', ParseIntPipe) id: number) {
        return this.service.listItems(id);
    }
}
