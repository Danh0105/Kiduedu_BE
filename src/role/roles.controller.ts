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
import { RolesService } from './roles.service';
import { CreateRoleDto } from './dto/create-role.dto';
import { UpdateRoleDto } from './dto/update-role.dto';

@Controller('roles')
export class RolesController {
    constructor(private readonly rolesService: RolesService) { }

    /* ===============================
        CREATE ROLE
       POST /roles
    =============================== */
    @Post()
    create(@Body() dto: CreateRoleDto) {
        return this.rolesService.create(dto);
    }

    /* ===============================
        GET ALL ROLES
       GET /roles
    =============================== */
    @Get()
    findAll() {
        return this.rolesService.findAll();
    }
    /* ===============================
        GET ALL PERMISSIONS
       GET /roles/permissions
    =============================== */
    @Get('permissions')
    findAllPermissions() {
        return this.rolesService.findAllPermissions();
    }
    /* ===============================
        GET ROLE BY ID
       GET /roles/:id
    =============================== */
    @Get(':id')
    findOne(@Param('id', ParseIntPipe) id: number) {
        return this.rolesService.findOne(id);
    }

    /* ===============================
        UPDATE ROLE
       PATCH /roles/:id
    =============================== */
    @Patch(':id')
    update(
        @Param('id', ParseIntPipe) id: number,
        @Body() dto: UpdateRoleDto,
    ) {
        return this.rolesService.update(id, dto);
    }

    /* ===============================
        DELETE ROLE
       DELETE /roles/:id
    =============================== */
    @Delete(':id')
    remove(@Param('id', ParseIntPipe) id: number) {
        return this.rolesService.remove(id);
    }

    /* ===============================
        ADD PERMISSIONS TO ROLE
       POST /roles/:id/permissions
    =============================== */
    @Post(':id/permissions')
    addPermissions(
        @Param('id', ParseIntPipe) roleId: number,
        @Body('permissionIds') permissionIds: number[],
    ) {
        return this.rolesService.addPermissions(roleId, permissionIds);
    }

    /* ===============================
        REMOVE PERMISSIONS FROM ROLE
       DELETE /roles/:id/permissions
    =============================== */
    @Delete(':id/permissions')
    removePermissions(
        @Param('id', ParseIntPipe) roleId: number,
        @Body('permissionIds') permissionIds: number[],
    ) {
        return this.rolesService.removePermissions(roleId, permissionIds);
    }


}
