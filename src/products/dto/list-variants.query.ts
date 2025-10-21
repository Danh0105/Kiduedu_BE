import { IsInt, IsOptional, IsString, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class ListVariantsQuery {
    @IsOptional() @Type(() => Number) @IsInt() @Min(1)
    page?: number = 1;

    @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(100)
    limit?: number = 20;

    @IsOptional() @IsString()
    search?: string; // tìm theo variantName hoặc sku

    @IsOptional() @Type(() => Number) @IsInt()
    status?: number; // 1/0

    // Lấy thêm “giá hiện hành” (true/false)
    @IsOptional()
    withPrice?: 'true' | 'false';
}
