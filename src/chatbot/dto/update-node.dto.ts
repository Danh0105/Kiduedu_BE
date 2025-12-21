import { IsBoolean, IsOptional, IsString } from 'class-validator';

export class UpdateNodeDto {
    @IsOptional()
    @IsString()
    content?: string;

    @IsOptional()
    @IsBoolean()
    isStart?: boolean;
}
