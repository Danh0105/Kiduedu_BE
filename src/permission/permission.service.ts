import {
    Injectable,
    NotFoundException,
    ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Permission } from '../permission/entities/permission.entity';
import { CreatePermissionDto } from './dto/create-permission.dto';
import { UpdatePermissionDto } from './dto/update-permission.dto';

@Injectable()
export class PermissionsService {
    constructor(
        @InjectRepository(Permission)
        private readonly permissionRepo: Repository<Permission>,
    ) { }

    findAll() {
        return this.permissionRepo.find({ order: { id: 'ASC' } });
    }

    create(dto: CreatePermissionDto) {
        return this.permissionRepo.save(dto);
    }

    async update(id: number, dto: UpdatePermissionDto) {
        const permission = await this.permissionRepo.findOne({ where: { id } });
        if (!permission) throw new NotFoundException('Permission not found');

        Object.assign(permission, dto);
        return this.permissionRepo.save(permission);
    }

    async remove(id: number) {
        const permission = await this.permissionRepo.findOne({ where: { id } });
        if (!permission) throw new NotFoundException('Permission not found');

        await this.permissionRepo.remove(permission);
    }
}

