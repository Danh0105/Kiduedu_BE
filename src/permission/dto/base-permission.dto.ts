import { IsOptional, IsString } from 'class-validator';

export class BasePermissionDto {


    @IsOptional()
    @IsString()
    description?: string;
}
