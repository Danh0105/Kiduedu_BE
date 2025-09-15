import { Expose, Type } from 'class-transformer';

class ImageResponseDto {
  @Expose()
  image_id: number;

  @Expose()
  image_url: string;
}

class CategoryResponseDto {
  @Expose()
  category_id: number;

  @Expose()
  category_name: string;
}

export class ProductResponseDto {
  @Expose()
  product_id: number;

  @Expose()
  product_name: string;

  @Expose()
  sku: string;

  @Expose()
  short_description: string;

  @Expose()
  long_description: string;

  @Expose()
  status: number;

  @Expose()
  price: number;

  @Expose()
  stock_quantity: number;

  @Expose()
  created_at: Date;

  @Expose()
  updated_at: Date;

  @Expose()
  @Type(() => CategoryResponseDto)
  category: CategoryResponseDto;

  @Expose()
  @Type(() => ImageResponseDto)
  images: ImageResponseDto[];
}
