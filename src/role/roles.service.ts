// src/roles/roles.service.ts
import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Role } from './entities/role.entity';
import { Permission } from '../permission/entities/permission.entity';
import { CreateRoleDto } from './dto/create-role.dto';
import { UpdateRoleDto } from './dto/update-role.dto';

@Injectable()
export class RolesService {
    constructor(
        @InjectRepository(Role)
        private readonly roleRepo: Repository<Role>,

        @InjectRepository(Permission)
        private readonly permissionRepo: Repository<Permission>,
    ) { }

    /* ===============================
        CREATE ROLE
    =============================== */
    async create(dto: CreateRoleDto): Promise<Role> {
        const existed = await this.roleRepo.findOne({
            where: { name: dto.name },
        });

        if (existed) {
            throw new ConflictException('Role already exists');
        }

        const permissions = dto.permissionIds?.length
            ? await this.permissionRepo.find({
                where: { id: In(dto.permissionIds) },
            })
            : [];

        const role = this.roleRepo.create({
            name: dto.name,
            description: dto.description,
            permissions,
        });

        return this.roleRepo.save(role);
    }

    /* ===============================
        GET ALL ROLES
    =============================== */
    async findAll(): Promise<Role[]> {
        return this.roleRepo.find();
    }

    /* ===============================
        GET ROLE BY ID
    =============================== */
    async findOne(id: number): Promise<Role> {
        const role = await this.roleRepo.findOne({
            where: { id },
        });

        if (!role) {
            throw new NotFoundException('Role not found');
        }

        return role;
    }

    /* ===============================
        UPDATE ROLE
    =============================== */
    async update(id: number, dto: UpdateRoleDto): Promise<Role> {
        const role = await this.findOne(id);

        if (dto.permissionIds) {
            role.permissions = await this.permissionRepo.find({
                where: { id: In(dto.permissionIds) },
            });
        }

        if (dto.name !== undefined) role.name = dto.name;
        if (dto.description !== undefined) role.description = dto.description;

        return this.roleRepo.save(role);
    }

    /* ===============================
        DELETE ROLE
    =============================== */
    async remove(id: number): Promise<void> {
        const role = await this.findOne(id);
        await this.roleRepo.remove(role);
    }

    /* ===============================
        ADD PERMISSIONS TO ROLE
    =============================== */
    async addPermissions(roleId: number, permissionIds: number[]): Promise<Role> {
        const role = await this.findOne(roleId);

        const permissions = await this.permissionRepo.find({
            where: { id: In(permissionIds) },
        });

        role.permissions = Array.from(
            new Map([...role.permissions, ...permissions].map(p => [p.id, p])).values(),
        );

        return this.roleRepo.save(role);
    }

    /* ===============================
        REMOVE PERMISSIONS FROM ROLE
    =============================== */
    async removePermissions(roleId: number, permissionIds: number[]): Promise<Role> {
        const role = await this.findOne(roleId);

        role.permissions = role.permissions.filter(
            p => !permissionIds.includes(p.id),
        );

        return this.roleRepo.save(role);
    }

    findAllPermissions() {
        return this.permissionRepo.find({
            order: { id: 'ASC' },
        });
    }
}
