import {
  Controller,
  Post,
  Body,
  Get,
  Param,
  Put,
  Delete,
  UseGuards,
  HttpStatus,
} from '@nestjs/common';
import { ProductService } from './product.service';
import { CreateProductDto } from './dto/create-product.dto';
import { AuthGuard } from '../auth/auth.guard';

@Controller('products')
export class ProductController {
  constructor(private productService: ProductService) { }

  @UseGuards(AuthGuard)
  @Post()
  async create(@Body() body: CreateProductDto) {
    const product = await this.productService.create(body);
    return {
      success: true,
      message: 'Product created successfully',
      statusCode: HttpStatus.CREATED,
      data: product,
    };
  }

  @UseGuards(AuthGuard)
  @Get()
  async findAll() {
    const products = await this.productService.findAll();
    return {
      success: true,
      message: 'Products retrieved successfully',
      statusCode: HttpStatus.OK,
      data: products,
    };
  }

  @UseGuards(AuthGuard)
  @Get(':id')
  async findOne(@Param('id') id: number) {
    const product = await this.productService.findOne(id);
    return {
      success: true,
      message: 'Product retrieved successfully',
      statusCode: HttpStatus.OK,
      data: product,
    };
  }

  @UseGuards(AuthGuard)
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

  @UseGuards(AuthGuard)
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
