import { IsInt } from 'class-validator';

export class AddVariantOptionDto {
  @IsInt()
  optionValueId: number;
}
