import { IsOptional, IsString, IsInt } from 'class-validator';

export class UpdateOptionDto {
    @IsOptional()
    @IsString()
    label?: string;

    @IsOptional()
    @IsString()
    nextNodeKey?: string;

    @IsOptional()
    @IsInt()
    sortOrder?: number;
}
