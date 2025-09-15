import {
  Controller,
  Post,
  Body,
  Get,
  Param,
  Put,
  Delete,
  HttpStatus,
  Query,
} from '@nestjs/common';
import { ProductService } from './product.service';
import { CreateProductDto } from './dto/create-product.dto';
import { Public } from 'src/auth/public.decorator';
import { plainToInstance } from 'class-transformer';
import { ProductResponseDto } from './dto/ProductResponse.dto';
import { PaginatedResponseDto } from './dto/PaginatedResponse.dto';

@Controller('products')
export class ProductController {
  constructor(private readonly productService: ProductService) { }

  @Public()
  @Post()
  async create(@Body() body: CreateProductDto) {
    const product = await this.productService.create(body);
    return {
      success: true,
      message: 'Product created successfully',
      statusCode: HttpStatus.CREATED,
      data: plainToInstance(ProductResponseDto, product, {
        excludeExtraneousValues: true,
      }),
    };
  }

  @Public()
  @Get()
  async findAll(@Query('page') page = 1, @Query('limit') limit = 12) {
    const [products, total] = await this.productService.findAllPaginated(
      Number(page),
      Number(limit),
    );

    return plainToInstance(PaginatedResponseDto<ProductResponseDto>, {
      success: true,
      message: 'Products retrieved successfully',
      statusCode: HttpStatus.OK,
      meta: {
        total,
        page: Number(page),
        limit: Number(limit),
        last_page: Math.ceil(total / limit),
      },
      data: plainToInstance(ProductResponseDto, products, {
        excludeExtraneousValues: true,
      }),
    });
  }

  @Public()
  @Get(':id')
  async findOne(@Param('id') id: number) {
    const product = await this.productService.findOne(id);
    return plainToInstance(PaginatedResponseDto<ProductResponseDto>, {
      success: true,
      message: 'Products retrieved successfully',
      statusCode: HttpStatus.OK,
      data: plainToInstance(ProductResponseDto, product, {
        excludeExtraneousValues: true,
      }),
    });
  }

  @Public()
  @Put(':id')
  async update(
    @Param('id') id: number,
    @Body() body: Partial<CreateProductDto>,
  ) {
    const updated = await this.productService.update(id, body);
    return {
      success: true,
      message: 'Product updated successfully',
      statusCode: HttpStatus.OK,
      data: updated,
    };
  }

  @Public()
  @Delete(':id')
  async remove(@Param('id') id: number) {
    await this.productService.remove(id);
    return {
      success: true,
      message: 'Product deleted successfully',
      statusCode: HttpStatus.OK,
      data: null,
    };
  }
}
