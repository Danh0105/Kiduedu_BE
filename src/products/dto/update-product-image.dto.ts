import { IsString, IsOptional, IsBoolean } from 'class-validator';

export class UpdateProductImageDto {
    /** Cloudinary public_id - dùng để xác định ảnh cũ (không xóa nhầm) */
    @IsString()
    @IsOptional()
    public_id?: string | null;

    /** URL ảnh (bắt buộc nếu là ảnh mới hoặc ảnh cũ chưa có) */
    @IsString()
    imageUrl: string;

    /** Mô tả ảnh (alt text) */
    @IsString()
    @IsOptional()
    alt_text?: string;

    /** Ảnh chính hay không */
    @IsBoolean()
    @IsOptional()
    is_primary?: boolean;
}