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
  UseInterceptors,
  UploadedFiles,
  UploadedFile,
  ParseIntPipe,
  BadRequestException,
  ValidationPipe,
} from '@nestjs/common';
import { ProductService } from '../services/product.service';
import { CreateProductDto } from '../dto/create-product.dto';
import { UpdateProductDto } from '../dto/update-product.dto';
import { Public } from 'src/auth/public.decorator';
import { plainToInstance } from 'class-transformer';
import { ProductResponseDto } from '../dto/ProductResponse.dto';
import { PaginatedResponseDto } from '../dto/PaginatedResponse.dto';
import { AnyFilesInterceptor, FileFieldsInterceptor, FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';

@Controller('products')
export class ProductController {
  constructor(private readonly productService: ProductService) { }

  // product.controller.ts
  @Public()
  @Post()
  @UseInterceptors(
    AnyFilesInterceptor({
      limits: { fileSize: 10 * 1024 * 1024 },
      fileFilter: (req, file, cb) => {
        const allowed = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
        if (allowed.includes(file.mimetype)) cb(null, true);
        else cb(new BadRequestException('Chỉ chấp nhận ảnh'), false);
      },
    }),
  )
  async create(
    @UploadedFiles() files: Express.Multer.File[],
    @Body(new ValidationPipe({ transform: true })) body: any,
  ) {
    // Parse FE JSON
    let variants = [];
    try {
      variants = body.variants ? JSON.parse(body.variants) : [];
    } catch { }

    return this.productService.create(
      { ...body, variants },
      files,
    );
  }


  @Public()
  @Get()
  async findAll(@Query('page') page = 1, @Query('limit') limit = 12) {
    const { items, total } = await this.productService.findAllPaginated(page, limit);

    return {
      success: true,
      message: "Products retrieved successfully",
      statusCode: HttpStatus.OK,
      meta: {
        total,
        page: Number(page),
        limit: Number(limit),
        last_page: Math.ceil(total / limit),
      },
      data: items,
    };
  }


  @Public()
  @Get(':id')
  async findOne(@Param('id') id: number) {
    const product = await this.productService.findOne(id);

    return {
      success: true,
      message: "Product retrieved successfully",
      statusCode: HttpStatus.OK,
      data: product // FE nhận object
    };
  }

  @Public()
  @Put(':id')
  @UseInterceptors(
    AnyFilesInterceptor({
      limits: { fileSize: 10 * 1024 * 1024 }, // 10MB
      fileFilter: (req, file, cb) => {
        const allowed = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
        if (allowed.includes(file.mimetype)) cb(null, true);
        else cb(new BadRequestException('Chỉ chấp nhận ảnh'), false);
      },
    }),
  )
  async update(
    @Param('id', ParseIntPipe) id: number,
    @UploadedFiles() files: Express.Multer.File[], // ← Nhận mảng tất cả file
    @Body(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: false,
        forbidUnknownValues: false,
        skipMissingProperties: true,
      }),
    ) body: any,
  ) {
    let images = [];
    let variants = [];

    try {
      images = body.images ? JSON.parse(body.images as string) : [];
      variants = body.variants ? JSON.parse(body.variants as string) : [];
    } catch (e) {
      console.log('Parse error:', e);
    }

    console.log('=== DEBUG CONTROLLER ===');
    console.log('Raw body.variants:', body.variants);
    console.log('Parsed variants:', variants);
    console.log('Files:', files?.map(f => f.fieldname));

    // TRUYỀN ĐÚNG KIỂU CHO SERVICE
    return this.productService.update(id, { ...body, images, variants }, files);
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
  @Post('upload-image')
  @UseInterceptors(
    AnyFilesInterceptor({
      storage: diskStorage({
        destination: './temp-uploads',
        filename: (req, file, callback) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          const ext = extname(file.originalname);
          callback(null, `tmp-${uniqueSuffix}${ext}`);
        },
      }),
      limits: { fileSize: 10 * 1024 * 1024 }, // 10MB
      fileFilter: (req, file, callback) => {
        // Chỉ cho phép ảnh
        if (!file.originalname.match(/\.(jpg|jpeg|png|webp|gif)$/i)) {
          return callback(new Error('Chỉ chấp nhận file ảnh!'), false);
        }
        // Cho phép: newImages và mọi field bắt đầu bằng variantImage_
        if (file.fieldname === 'newImages' || file.fieldname.startsWith('variantImage_')) {
          return callback(null, true);
        }
        // Chặn các field lạ
        return callback(new Error('Field không hợp lệ!'), false);
      },
    }),
  )
  uploadFile(@UploadedFile() file: Express.Multer.File) {
    return {
      imageUrl: `/uploads/products/${file.filename}`, // lưu trong DB
    };
  }

}
