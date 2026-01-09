import { IsNotEmpty } from 'class-validator';
import { BasePermissionDto } from './base-permission.dto';

export class CreatePermissionDto extends BasePermissionDto {
    @IsNotEmpty()
    code: string;
}