import { Expose, Type } from 'class-transformer';
import { ProductAttributeValue } from '../entities/product-attribute-value.entity'; // Import ProductAttributeValue if you want to include it

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

// If you want to include attribute values, define a DTO for it
class ProductAttributeValueResponseDto {
  @Expose()
  product_attribute_value_id: number;

  @Expose()
  attribute_value: string;

  // You might want to include the attribute name as well
  @Expose()
  attribute_name: string; // Assuming you have a way to get the attribute name
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
  // Thêm các cột mới: specs, origin, user_manual, caution_notes
  specs: any; // Keep as any, or define a more specific DTO if specs has a fixed structure

  @Expose()
  origin: string;

  @Expose()
  user_manual: string;

  @Expose()
  caution_notes: string;

  @Expose()
  @Type(() => CategoryResponseDto)
  category: CategoryResponseDto;

  @Expose()
  @Type(() => ImageResponseDto)
  images: ImageResponseDto[];

  // Nếu bạn muốn hiển thị các giá trị thuộc tính trong DTO phản hồi
  // @Expose()
  // @Type(() => ProductAttributeValueResponseDto)
  // attributeValues: ProductAttributeValueResponseDto[];
}