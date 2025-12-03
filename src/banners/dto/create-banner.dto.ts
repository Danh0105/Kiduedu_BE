import { IsString, IsBoolean, IsOptional } from 'class-validator';

export class CreateBannerDto {
    @IsString()
    imageUrl: string;

    @IsOptional()
    @IsBoolean()
    isActive?: boolean;
}
