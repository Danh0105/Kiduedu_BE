import {
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository, In, IsNull, Not, LessThan } from 'typeorm';
import { Product } from '../entities/product.entity';
import { ProductImage } from '../entities/product-image.entity';
import { ProductVariant } from '../entities/product-variant.entity';
import { Category } from '../../categories/entities/category.entity';
import { ProductVariantPrice } from '../entities/product-variant-price.entity';
import { ProductVariantInventory } from '../entities/product-variant-inventory.entity';
import { UploadService } from '../../upload/upload.service';
import { promises as fs } from 'fs';
import { join, relative } from 'path';
import { InventoryReceipt } from '../entities/inventory-receipt.entity';
import { Supplier } from '../entities/supplier.entity';
import { InventoryReceiptItem } from '../entities/inventory-receipt-item.entity';
import { InventoryService } from './inventory.service';

type UserManual = { pdf?: string; video?: string; steps: string[] } | null;
interface InventoryInput {
  items?: any[];
  receiptDate?: string | Date;
  supplierId?: number | string;
  note?: string;
  receiptCode?: string;
}


@Injectable()
export class ProductService {
  constructor(


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

    private inventoryService: InventoryService
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

    /* =======================================================
        1) CREATE PRODUCT
    ======================================================= */
    const newProduct = await this.productRepository.save({
      productName: data.productName,
      categoryId: data.categoryId,
      origin: data.origin,
      status: data.status ?? 1,
      shortDescription: data.shortDescription,
      longDescription: data.longDescription,
    });

    /* =======================================================
        2) PRODUCT IMAGES
    ======================================================= */
    const productImages = files.filter(f => f.fieldname === "newImages");
    let savedImages: ProductImage[] = [];

    for (const file of productImages) {
      const url = await this.uploadService.uploadFile(file);

      const img = await this.productImageRepository.save({
        product: { productId: newProduct.productId },
        imageUrl: url,
        altText: "",
        isPrimary: false,
      });

      savedImages.push(img);
    }

    // Ảnh đại diện
    if (savedImages.length > 0) {
      await this.productImageRepository.update(
        { imageId: savedImages[0].imageId },
        { isPrimary: true }
      );
    }

    /* =======================================================
        3) CREATE VARIANTS
    ======================================================= */

    for (const variant of data.variants || []) {

      // Tạo biến thể
      const variantEntity = await this.variantRepository.save({
        product: { productId: newProduct.productId },
        sku: variant.sku,
        variantName: variant.variantName,
        barcode: variant.barcode,
        specs: variant.specs,
      });

      /* -------------------------------------------
          3.1 Save Variant Image
      ------------------------------------------- */
      const imageField = `variantImage_${variant.sku}`;
      const variantImg = files.find(f => f.fieldname === imageField);

      if (variantImg) {
        const url = await this.uploadService.uploadFile(variantImg);
        await this.variantRepository.update(
          { variantId: variantEntity.variantId },
          { imageUrl: url }
        );
      }

      /* -------------------------------------------
          3.2 Save Prices
      ------------------------------------------- */
      for (const p of variant.prices || []) {
        await this.priceRepository.save({
          variantId: variantEntity.variantId,
          priceType: p.priceType,
          price: Number(p.price),
          currencyCode: "VND",
          startAt: p.startAt ? new Date(p.startAt) : new Date(),
          endAt: p.endAt ? new Date(p.endAt) : null,
        });
      }

      /* =======================================================
          4) HANDLE INVENTORY USING INVENTORY SERVICE
      ======================================================= */


      const inventories: InventoryInput[] = ([] as InventoryInput[]).concat(variant.inventory || []);
      for (const inv of inventories) {
        if (!inv) continue;

        const itemsRaw = ([] as any[]).concat(inv.items || []);

        const mappedItems = itemsRaw.map((i: any) => ({
          variantId: variantEntity.variantId,
          quantity: Number(i.qty),
          unitCost: Number(i.unitCost),
        }));

        if (mappedItems.length === 0) continue;

        const receiptDto = {
          type: "import",
          date: inv.receiptDate,
          supplierId: Number(inv.supplierId),
          note: inv.note,
          referenceNo: inv.receiptCode,
          items: mappedItems,
        };

        await this.inventoryService.create(receiptDto);
      }


      /* =======================================================
          DONE
      ======================================================= */

    }
    const resProduct = await this.productRepository.findOne({
      where: { productId: newProduct.productId },
      relations: [
        'images',
        'variants',
        'variants.prices',
        'category',
      ],
    });

    return {
      message: 'Product created successfully',
      data: resProduct,
    };
  }


  // ============================================================
  // UPDATE PRODUCT — SMART UPDATE + FILE DELETE
  // ============================================================

  async update(id: number, data: any, files: Express.Multer.File[]) {


    await this.productRepository.update(id, {
      productName: data.productName,
      categoryId: data.categoryId,
      origin: data.origin,
      status: data.status,
      shortDescription: data.shortDescription,
      longDescription: data.longDescription,
    });

    // ========== IMAGE UPDATE WITH FILE DELETE ==========


    // 1. Lấy ảnh hiện có trong DB
    const existingImages = await this.productImageRepository.find({
      where: { product: { productId: id } },
    });

    existingImages.forEach((img) => {
    });

    const feImages = data.images || [];

    feImages.forEach((img: any, i: number) => {
    });

    // 2. Tìm ảnh nào cần xóa (DB có nhưng FE không có)
    const feImageIds = feImages.filter((x: any) => x.imageId).map((x: any) => x.imageId);

    const toRemove = existingImages.filter(
      (dbImg) => !feImageIds.includes(dbImg.imageId)
    );

    toRemove.forEach((img) => {
    });

    for (const img of toRemove) {
      await this.safeUnlink(img.imageUrl);

      await this.productImageRepository.delete({ imageId: img.imageId });
    }

    // 3. Lưu ảnh cũ (UPDATE)
    for (const img of feImages) {
      if (img.imageId) {
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

    for (const file of newImages) {
      const savedUrl = await this.uploadService.uploadFile(file);

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

    finalImages.forEach((img) => {
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
          startAt: p.startAt ? new Date(p.startAt) : new Date(),
          endAt: p.endAt ? new Date(p.endAt) : null,
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
    const product = await this.productRepository.findOne({
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
          specs: this.parseJson(v.specs, {}),
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
    const product = await this.productRepository.findOne({
      where: { productId: id },
      relations: ['images', 'variants'],
    });

    if (!product) throw new NotFoundException('Sản phẩm không tồn tại');

    for (const img of product.images || []) {
      await this.safeUnlink(img.imageUrl);
    }


    const variants = await this.variantRepository.find({
      where: { product: { productId: id } },
    });
    for (const v of variants) {
      if (v.imageUrl) await this.safeUnlink(v.imageUrl);
    }

    await this.productRepository.remove(product);
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  async findAllPaginated(page = 1, limit = 20) {
    const [items, total] = await this.productRepository.findAndCount({
      relations: [
        'category',
        'images',
        'variants',
        'variants.prices',
        'variants.inventory',
        'createdBy'
      ],
      order: { productId: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    return { items, total, page, limit, pages: Math.ceil(total / limit) };
  }
}
