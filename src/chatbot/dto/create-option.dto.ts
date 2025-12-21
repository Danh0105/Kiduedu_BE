import { IsInt, IsOptional, IsString } from 'class-validator';

export class CreateOptionDto {
    @IsInt()
    nodeId: number;

    @IsString()
    label: string;

    @IsOptional()
    @IsString()
    nextNodeKey?: string;

    @IsOptional()
    @IsInt()
    sortOrder?: number;
}
