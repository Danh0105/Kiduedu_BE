import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository, In, IsNull, Not, LessThan } from 'typeorm';
import { Product } from '../entities/product.entity';
import { ProductImage } from '../entities/product-image.entity';
import { ProductVariant } from '../entities/product-variant.entity';
import { Category } from '../../categories/entities/category.entity';
import { CreateProductDto } from '../dto/create-product.dto';
import { ProductVariantPrice } from '../entities/product-variant-price.entity';
import { ProductVariantInventory } from '../entities/product-variant-inventory.entity';
import { UpdateProductDto } from '../dto/update-product.dto';
import { UploadService } from '../../upload/upload.service';
import { promises as fs } from 'fs';
import { join, relative } from 'path';
import { InitialReceiptDto } from '../dto/initial-receipt.dto';
import { InventoryReceipt } from '../entities/inventory-receipt.entity';
import { Supplier } from '../entities/supplier.entity';
import { InventoryReceiptItem } from '../entities/inventory-receipt-item.entity';

type UserManual = { pdf?: string; video?: string; steps: string[] } | null;

@Injectable()
export class ProductService {
  constructor(
    @InjectRepository(Product)
    private productRepo: Repository<Product>,

    @InjectRepository(ProductImage)
    private imageRepo: Repository<ProductImage>,

    @InjectRepository(ProductVariant)
    private variantRepo: Repository<ProductVariant>,

    @InjectRepository(ProductVariantPrice)
    private priceRepo: Repository<ProductVariantPrice>,

    @InjectRepository(Category)
    private categoryRepo: Repository<Category>,

    @InjectRepository(ProductVariantInventory)
    private inventoryRepo: Repository<ProductVariantInventory>,

    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,

    @InjectRepository(ProductImage)
    private readonly productImageRepository: Repository<ProductImage>,

    @InjectRepository(ProductVariant)
    private readonly variantRepository: Repository<ProductVariant>,

    @InjectRepository(ProductVariantPrice)
    private readonly priceRepository: Repository<ProductVariantPrice>,

    @InjectRepository(InventoryReceipt)
    private readonly receiptRepo: Repository<InventoryReceipt>,

    @InjectRepository(Supplier)
    private readonly supplierRepo: Repository<Supplier>,

    @InjectRepository(InventoryReceiptItem)
    private readonly receiptItemRep: Repository<InventoryReceiptItem>,

    private dataSource: DataSource,
    private readonly uploadService: UploadService,
  ) { }

  // ============================================================
  // FILE DELETE HELPERS
  // ============================================================

  private uploadsDir = join(process.cwd(), 'public', 'uploads');

  private getLocalFilePath(imageUrl?: string): string | null {
    if (!imageUrl) return null;

    const idx = imageUrl.indexOf('/uploads/');
    if (idx === -1) return null;

    const rel = 'public/' + imageUrl.slice(idx + 1);
    const full = join(process.cwd(), rel);


    const diff = relative(this.uploadsDir, full);

    // Nếu diff bắt đầu bằng ".." → file nằm ngoài uploadsDir
    if (diff.startsWith('..') || diff.includes('..\\')) {
      return null;
    }

    return full;
  }

  private async safeUnlink(imageUrl?: string) {
    try {

      const p = this.getLocalFilePath(imageUrl);
      console.log("p", p);

      if (!p) return;
      await fs.unlink(p).catch(() => { });
    } catch { }
  }

  // ============================================================
  // OTHER HELPERS
  // ============================================================

  private normalizeUserManual(input: any): UserManual {
    if (!input) return null;
    if (typeof input === 'string') return { steps: [input] };
    if (typeof input === 'object') {
      return {
        pdf: typeof input.pdf === 'string' ? input.pdf : undefined,
        video: typeof input.video === 'string' ? input.video : undefined,
        steps: Array.isArray(input.steps)
          ? input.steps.filter((s): s is string => typeof s === 'string')
          : [],
      };
    }
    return null;
  }

  private parseJson<T>(input: any, fallback: T): T {
    if (input == null) return fallback;
    if (typeof input !== 'string') return input;
    try {
      return JSON.parse(input);
    } catch {
      return fallback;
    }
  }

  private pickCurrentPrice(prices: ProductVariantPrice[]) {
    const now = new Date();
    const active = prices.filter((p) => {
      const startOk = !p.startAt || new Date(p.startAt) <= now;
      const endOk = !p.endAt || new Date(p.endAt) > now;
      return startOk && endOk;
    });

    if (active.length === 0) return null;

    const priority = { sale: 0, promo: 1, retail: 2, base: 3 };

    return active.sort((a, b) => {
      const pa = priority[a.priceType] ?? 3;
      const pb = priority[b.priceType] ?? 3;
      if (pa !== pb) return pa - pb;
      return (b.startAt?.getTime() ?? 0) - (a.startAt?.getTime() ?? 0);
    })[0];
  }

  // ============================================================
  // CREATE PRODUCT
  // ============================================================

  async create(data: any, files: Express.Multer.File[]) {
    const newProduct = await this.productRepository.save({
      productName: data.productName,
      categoryId: data.categoryId,
      price: data.price,
      origin: data.origin,
      status: data.status ?? 1,
      shortDescription: data.shortDescription,
      longDescription: data.longDescription,
    });

    const newProductImages = files.filter((f) => f.fieldname === 'newImages');
    let savedImages: ProductImage[] = [];

    for (const file of newProductImages) {
      const savedUrl = await this.uploadService.uploadFile(file);
      const img = await this.productImageRepository.save({
        product: { productId: newProduct.productId },
        imageUrl: savedUrl,
        altText: '',
        isPrimary: false,
      });
      savedImages.push(img);
    }

    if (savedImages.length > 0) {
      await this.productImageRepository.update(
        { imageId: savedImages[0].imageId },
        { isPrimary: true },
      );
    }

    const removeExpiredPromoByVariant = async (variantId: number) => {
      const now = new Date();
      await this.priceRepository.delete({
        variantId,
        priceType: 'promo',
        endAt: LessThan(now),
      });
    };

    for (const variant of data.variants || []) {
      const variantEntity = await this.variantRepository.save({
        product: { productId: newProduct.productId },
        sku: variant.sku,
        variantName: variant.variantName,
        barcode: variant.barcode,
        attributes: variant.attributes,
        specs: variant.specs,
      });

      const fileKey = `variantImage_${variant.sku}`;
      const uploadedVariantImage = files.find(
        (f) => f.fieldname === fileKey,
      );

      if (uploadedVariantImage) {
        const savedUrl = await this.uploadService.uploadFile(
          uploadedVariantImage,
        );
        await this.variantRepository.update(
          { variantId: variantEntity.variantId },
          { imageUrl: savedUrl },
        );
      }

      await removeExpiredPromoByVariant(variantEntity.variantId);

      for (const p of variant.prices || []) {
        await this.priceRepository.save({
          variantId: variantEntity.variantId,
          priceType: p.priceType,
          currencyCode: 'VND',
          price: Number(p.price),
          startAt: p.startAt ? new Date(p.startAt) : new Date(),
          endAt: p.endAt ? new Date(p.endAt) : null,
        });
      }
    }

    return { message: 'Create OK', productId: newProduct.productId };
  }

  // ============================================================
  // UPDATE PRODUCT — SMART UPDATE + FILE DELETE
  // ============================================================

  async update(id: number, data: any, files: Express.Multer.File[]) {
    console.log('=========== SERVICE UPDATE ===========');
    console.log('Product ID:', id);

    await this.productRepository.update(id, {
      productName: data.productName,
      categoryId: data.categoryId,
      price: data.price,
      origin: data.origin,
      status: data.status,
      shortDescription: data.shortDescription,
      longDescription: data.longDescription,
    });

    // ========== IMAGE UPDATE WITH FILE DELETE ==========

    console.log("=========== SERVICE UPDATE ==========");
    console.log("Product ID:", id);

    // 1. Lấy ảnh hiện có trong DB
    const existingImages = await this.productImageRepository.find({
      where: { product: { productId: id } },
    });

    console.log("=== EXISTING IMAGES IN DB ===");
    existingImages.forEach((img) => {
      console.log("DB:", img.imageId, img.imageUrl, img.isPrimary);
    });

    const feImages = data.images || [];

    console.log("=== FE IMAGES ===");
    feImages.forEach((img: any, i: number) => {
      console.log(`FE[${i}] =>`, img.imageId, img.imageUrl, img.isPrimary);
    });

    // 2. Tìm ảnh nào cần xóa (DB có nhưng FE không có)
    const feImageIds = feImages.filter((x: any) => x.imageId).map((x: any) => x.imageId);

    const toRemove = existingImages.filter(
      (dbImg) => !feImageIds.includes(dbImg.imageId)
    );

    console.log("=== WILL REMOVE ===");
    toRemove.forEach((img) => {
      console.log("REMOVE:", img.imageId, img.imageUrl);
    });

    for (const img of toRemove) {
      console.log("Deleting file:", img.imageUrl);
      await this.safeUnlink(img.imageUrl);

      console.log("Deleting DB record:", img.imageId);
      await this.productImageRepository.delete({ imageId: img.imageId });
    }

    // 3. Lưu ảnh cũ (UPDATE)
    console.log("=== SAVING EXISTING FE IMAGES (UPDATE) ===");
    for (const img of feImages) {
      if (img.imageId) {
        console.log("Updating:", img.imageId, img.imageUrl);

        await this.productImageRepository.save({
          imageId: img.imageId, // ⭐ UPDATE ảnh cũ
          product: { productId: id },
          imageUrl: img.imageUrl,
          altText: img.altText ?? "",
          isPrimary: img.isPrimary ?? false,
        });
      }
    }

    // 4. Xử lý ảnh mới upload
    const newImages = files.filter((f) => f.fieldname === "newImages");

    console.log("=== NEW UPLOADED FILES ===");
    newImages.forEach((f) => console.log("File:", f.originalname));

    for (const file of newImages) {
      const savedUrl = await this.uploadService.uploadFile(file);

      console.log("Saving NEW image:", savedUrl);

      await this.productImageRepository.save({
        product: { productId: id },
        imageUrl: savedUrl,
        altText: "",
        isPrimary: false,
      });
    }

    // 5. Debug cuối sau khi update
    const finalImages = await this.productImageRepository.find({
      where: { product: { productId: id } },
      order: { imageId: "ASC" },
    });

    console.log("=== FINAL DB IMAGES ===");
    finalImages.forEach((img) => {
      console.log("FINAL:", img.imageId, img.imageUrl, img.isPrimary);
    });

    // ========== VARIANT UPDATE ==========

    const dbVariants = await this.variantRepository.find({
      where: { product: { productId: id } },
      select: ['variantId'],
    });

    const feVariantIds = (data.variants || [])
      .filter((v) => v.variantId)
      .map((v) => v.variantId);

    const toDeleteIds = dbVariants
      .filter((dbv) => !feVariantIds.includes(dbv.variantId))
      .map((v) => v.variantId);

    if (toDeleteIds.length > 0) {
      const variantsToDelete = await this.variantRepository.findBy({
        variantId: In(toDeleteIds),
      });

      for (const v of variantsToDelete) {
        if (v.imageUrl) await this.safeUnlink(v.imageUrl);
      }

      await this.variantRepository.delete(toDeleteIds);
    }

    for (const variant of data.variants || []) {
      let variantEntity;

      if (!variant.variantId) {
        variantEntity = await this.variantRepository.save({
          product: { productId: id },
          sku: variant.sku,
          variantName: variant.variantName,
          barcode: variant.barcode,
          attributes: variant.attributes,
          specs: variant.specs,
          imageUrl: variant.imageUrl || null,
        });
      } else {
        await this.variantRepository.update(
          { variantId: variant.variantId },
          {
            sku: variant.sku,
            variantName: variant.variantName,
            barcode: variant.barcode,
            attributes: variant.attributes,
            specs: variant.specs,
            imageUrl: variant.imageUrl || null,
          },
        );

        variantEntity = await this.variantRepository.findOneBy({
          variantId: variant.variantId,
        });
      }

      const fileKey = `variantImage_${variant.sku}`;
      const uploadedVariantImage = files.find(
        (f) => f.fieldname === fileKey,
      );

      if (uploadedVariantImage) {
        const existing = await this.variantRepository.findOneBy({
          variantId: variantEntity.variantId,
        });

        if (existing?.imageUrl) {
          await this.safeUnlink(existing.imageUrl);
        }

        const savedUrl = await this.uploadService.uploadFile(
          uploadedVariantImage,
        );

        await this.variantRepository.update(
          { variantId: variantEntity.variantId },
          { imageUrl: savedUrl },
        );
      }

      await this.priceRepository.delete({
        variantId: variantEntity.variantId,
      });

      for (const p of variant.prices || []) {
        await this.priceRepository.save({
          variantId: variantEntity.variantId,
          priceType: p.priceType,
          currencyCode: 'VND',
          price: Number(p.price),
          startAt: new Date(),
        });
      }
    }

    const updatedProduct = await this.productRepository.findOne({
      where: { productId: id },
      relations: [
        'images',
        'variants',
        'variants.prices',
        'category',
      ],
    });

    return {
      message: 'Update OK',
      data: updatedProduct,
    };
  }

  // ============================================================
  // FIND ONE
  // ============================================================

  async findOne(id: number): Promise<Product> {
    const product = await this.productRepo.findOne({
      where: { productId: id },
      relations: [
        'category',
        'images',
        'variants',
        'variants.prices',
        'variants.inventory',
      ],
      order: {
        images: { isPrimary: 'DESC', imageId: 'ASC' },
        variants: { variantId: 'ASC' },
      },
    });

    if (!product) throw new NotFoundException('Sản phẩm không tồn tại');

    product.cautionNotes = this.parseJson(product.cautionNotes, []);
    product.userManual = this.normalizeUserManual(product.userManual);

    if (product.variants?.length) {
      product.variants = product.variants.map((v) => {
        const currentPrice = this.pickCurrentPrice(v.prices || []);
        return {
          ...v,
          attributes: this.parseJson(v.attributes, {}),
          specs: this.parseJson(v.specs, []),
          currentPrice: currentPrice?.price ?? null,
          currentPriceType: currentPrice?.priceType ?? null,
          currency: currentPrice?.currencyCode ?? 'VND',
        };
      });
    }

    return product;
  }

  // ============================================================
  // DELETE PRODUCT — REMOVE FILES TOO
  // ============================================================

  async remove(id: number): Promise<void> {
    const product = await this.productRepo.findOne({
      where: { productId: id },
      relations: ['images', 'variants'],
    });

    if (!product) throw new NotFoundException('Sản phẩm không tồn tại');

    for (const img of product.images || []) {
      console.log(img.imageUrl);
      await this.safeUnlink(img.imageUrl);
    }


    const variants = await this.variantRepository.find({
      where: { product: { productId: id } },
    });
    for (const v of variants) {
      if (v.imageUrl) await this.safeUnlink(v.imageUrl);
    }

    await this.productRepo.remove(product);
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  async findAllPaginated(page = 1, limit = 20) {
    const [items, total] = await this.productRepo.findAndCount({
      relations: [
        'category',
        'images',
        'variants',
        'variants.prices',
        'variants.inventory',
      ],
      order: { productId: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    return { items, total, page, limit, pages: Math.ceil(total / limit) };
  }
}
