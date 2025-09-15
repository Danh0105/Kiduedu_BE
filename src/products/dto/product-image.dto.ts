import { IsString } from 'class-validator';

export class CreateProductImageDto {
  @IsString()
  image_url: string;

}
