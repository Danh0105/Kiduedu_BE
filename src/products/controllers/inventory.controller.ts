import {
    Controller,
    Post,
    Get,
    Param,
    Body,
    Delete,
    Patch,
    Put,
} from "@nestjs/common";
import { InventoryService } from "../services/inventory.service";

@Controller("inventory")
export class InventoryController {
    constructor(private service: InventoryService) { }

    // Tạo phiếu nhập / xuất
    @Post()
    create(@Body() body: any) {
        return this.service.create(body);
    }

    // Danh sách phiếu
    @Get()
    findAll() {
        return this.service.findAll();
    }

    // Chi tiết phiếu
    @Get(":id")
    findOne(@Param("id") id: string) {
        return this.service.findOne(Number(id));
    }

    // Xoá phiếu
    @Delete(":id")
    remove(@Param("id") id: string) {
        return this.service.remove(Number(id));
    }
    @Patch(':id')
    update(
        @Param('id') id: number,
        @Body() dto: any
    ) {
        return this.service.update(+id, dto);
    }



}
