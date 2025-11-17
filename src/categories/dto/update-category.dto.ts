import { IsNotEmpty, IsOptional, IsString } from "class-validator";

export class UpdateCategoryDto {
  @IsString()
  @IsNotEmpty()
  categoryName: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsOptional()
  parentCategoryId?: number | null;
}
