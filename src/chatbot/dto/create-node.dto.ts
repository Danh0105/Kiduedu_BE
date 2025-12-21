import { IsBoolean, IsOptional, IsString, IsNotEmpty } from 'class-validator';

export class CreateNodeDto {
    @IsString()
    @IsNotEmpty()
    key: string;

    @IsOptional()
    @IsString()
    content?: string;

    @IsOptional()
    @IsBoolean()
    isStart?: boolean;
}
