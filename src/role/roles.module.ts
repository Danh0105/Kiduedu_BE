import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Role } from './entities/role.entity';
import { RolesService } from './roles.service';
import { RolesController } from './roles.controller';
import { Permission } from '../permission/entities/permission.entity';
import { PermissionModule } from 'src/permission/permission.module';

@Module({
    imports: [
        TypeOrmModule.forFeature([Role, Permission]),
        PermissionModule
    ],
    providers: [RolesService],
    exports: [RolesService, TypeOrmModule],
    controllers: [RolesController],
})
export class RolesModule { }
