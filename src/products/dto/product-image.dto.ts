import { IsBoolean, IsOptional, IsString } from 'class-validator';

export class CreateProductImageDto {
  @IsString()
  imageUrl: string;

  @IsOptional()
  @IsString()
  publicId?: string;

  @IsOptional()
  @IsString()
  altText?: string;

  @IsBoolean()
  @IsOptional()
  isPrimary?: boolean = false;
}
