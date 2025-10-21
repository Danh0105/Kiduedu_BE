// src/products/dto/user-manual.dto.ts
import { IsArray, IsOptional, IsString, IsUrl } from 'class-validator';

export class UserManualDto {
    @IsOptional()
    @IsUrl()
    pdf?: string;

    @IsOptional()
    @IsUrl()
    video?: string;

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    steps?: string[];
}
