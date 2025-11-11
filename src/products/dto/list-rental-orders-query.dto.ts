// src/products/controllers/dto/list-rental-orders-query.dto.ts
import { IsBoolean, IsInt, IsOptional, IsString, Min } from 'class-validator';
import { Transform, Type } from 'class-transformer';

export class ListRentalOrdersQueryDto {
    @IsOptional()
    @Type(() => Number)
    @IsInt()
    @Min(1)
    page?: number;

    @IsOptional()
    @Type(() => Number)
    @IsInt()
    @Min(1)
    limit?: number;

    @IsOptional()
    @Type(() => Number)
    @IsInt()
    userId?: number;

    @IsOptional()
    @IsString()
    status?: string;

    // "true" | "1" | true => true
    @IsOptional()
    @IsBoolean()
    @Transform(({ value }) => value === true || value === 'true' || value === '1')
    withItems?: boolean;

    @IsOptional()
    @IsBoolean()
    @Transform(({ value }) => value === true || value === 'true' || value === '1')
    withUser?: boolean;

    // Có thể thêm validate định dạng YYYY-MM-DD nếu muốn
    @IsOptional()
    @IsString()
    createdFrom?: string;

    @IsOptional()
    @IsString()
    createdTo?: string;
}
