import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Product } from '../entities/product.entity';
import { ProductImage } from '../entities/product-image.entity';
import { ProductVariant } from '../entities/product-variant.entity';
import { Category } from '../../categories/entities/category.entity';
import { CreateProductDto } from '../dto/create-product.dto';
import { ProductVariantPrice } from '../entities/product-variant-price.entity';
import { CreateVariantPriceDto } from '../dto/create-variant-price.dto';
import { CreateProductVariantDto } from '../dto/create-product-variant.dto';
import { ProductVariantInventory } from '../entities/product-variant-inventory.entity';
import { InventoryReceipt } from '../entities/inventory-receipt.entity';
import { InventoryReceiptItem } from '../entities/inventory-receipt-item.entity';
import { Supplier } from '../entities/supplier.entity';

/* =========================== Helpers =========================== */
// Ưu tiên kiểu giá: sale → promo → retail → base
const PRICE_PRIORITY = ['sale', 'promo', 'retail', 'base'] as const;
type PriceType = (typeof PRICE_PRIORITY)[number];

type UserManual =
  | string
  | { pdf?: string; video?: string; steps?: string[] }
  | null;

function normalizeUserManual(
  input: any,
): { pdf?: string; video?: string; steps: string[] } | null {
  if (input == null) return null;

  // Trường hợp DB đang lưu chuỗi thuần
  if (typeof input === 'string') {
    return { steps: [input] };
  }

  // Trường hợp object JSONB đúng chuẩn/bán chuẩn
  if (typeof input === 'object' && !Array.isArray(input)) {
    const pdf = typeof input.pdf === 'string' ? input.pdf : undefined;
    const video = typeof input.video === 'string' ? input.video : undefined;
    const steps = Array.isArray(input.steps)
      ? (input.steps.filter((s: any) => typeof s === 'string') as string[])
      : [];
    return { pdf, video, steps };
  }

  // Các trường hợp còn lại (mảng, số, bool, …) → bỏ qua
  return null;
}

type SpecItem = {
  key: string;
  label: string;
  value: string;
  unit?: string | null;
  type?: 'text' | 'number' | 'boolean';
  group?: string | null;
  note?: string | null;
  order?: number;
};

// ================== Inventory & Phiếu nhập – chỉ dùng nội bộ ==================
type InitialReceiptItemInput = {
  /** Có thể map theo variantId hoặc variantSku */
  variantId?: number;
  variantSku?: string;
  quantity: number;
  unitCost: number;
};

type InitialReceiptInput = {
  /** Thông tin NCC – hoặc dùng supplierId sẵn có, hoặc tạo mới bằng supplierName */
  supplierId?: number;
  supplierName?: string;
  supplierPhone?: string;
  supplierEmail?: string;
  supplierAddress?: string;
  supplierNote?: string;

  /** Thông tin phiếu nhập */
  receiptCode?: string;
  receiptDate?: string; // 'YYYY-MM-DD'
  referenceNo?: string;
  note?: string;

  items: InitialReceiptItemInput[];
};

function toArray<T = any>(v: any): T[] {
  if (!v) return [];
  return Array.isArray(v) ? (v as T[]) : [];
}

function toObject<T extends object = Record<string, any>>(v: any): T {
  if (!v || typeof v !== 'object' || Array.isArray(v)) return {} as T;
  return v as T;
}

function toSpecArray(input: any): SpecItem[] {
  if (!input) return [];
  if (Array.isArray(input)) {
    return (input as any[])
      .filter(Boolean)
      .map((s: any) => ({
        key: String(s.key ?? ''),
        label: String(s.label ?? s.key ?? ''),
        value: String(s.value ?? ''),
        unit: s.unit ?? null,
        type: s.type ?? 'text',
        group: s.group ?? null,
        note: s.note ?? null,
        order: s.order ?? 0,
      })) as SpecItem[];
  }
  if (typeof input === 'object') {
    // nếu lỡ FE gửi dạng map {screen_size: {label, value...}}
    return Object.entries(input).map(([k, v]: [string, any]) => ({
      key: k,
      label: v?.label ?? k,
      value: String(v?.value ?? ''),
      unit: v?.unit ?? null,
      type: v?.type ?? 'text',
      group: v?.group ?? null,
      note: v?.note ?? null,
      order: v?.order ?? 0,
    }));
  }
  return [];
}

function sortSpecs(specs: SpecItem[]): SpecItem[] {
  return [...specs].sort((a, b) => (a?.order ?? 0) - (b?.order ?? 0));
}

/** Chọn giá hiện hành từ mảng prices đã load qua quan hệ */
function pickCurrentPrice(prices: any[]): any | null {
  if (!Array.isArray(prices) || prices.length === 0) return null;

  const now = new Date();
  const active = prices.filter((p) => {
    const startOk = p.startAt ? new Date(p.startAt) <= now : true;
    const endOk = p.endAt ? new Date(p.endAt) > now : true;
    return startOk && endOk;
  });

  const list = (active.length ? active : []) as any[];

  if (list.length === 0) return null;

  // sort theo: type priority → startAt desc
  list.sort((a, b) => {
    const pa = PRICE_PRIORITY.indexOf((a.priceType as PriceType) ?? 'base');
    const pb = PRICE_PRIORITY.indexOf((b.priceType as PriceType) ?? 'base');
    if (pa !== pb) return pa - pb;
    const sa = a.startAt ? new Date(a.startAt).getTime() : 0;
    const sb = b.startAt ? new Date(b.startAt).getTime() : 0;
    return sb - sa;
  });

  return list[0];
}
/* =============================================================== */

@Injectable()
export class ProductService {
  constructor(
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,

    @InjectRepository(ProductImage)
    private readonly imageRepo: Repository<ProductImage>,

    @InjectRepository(ProductVariant)
    private readonly variantRepo: Repository<ProductVariant>,

    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,

    private readonly ds: DataSource,

    @InjectRepository(ProductVariantPrice)
    private readonly productVariantPriceRepo: Repository<ProductVariantPrice>,

    // 🆕 Tồn kho + phiếu nhập + NCC
    @InjectRepository(ProductVariantInventory)
    private readonly variantInventoryRepo: Repository<ProductVariantInventory>,

    @InjectRepository(InventoryReceipt)
    private readonly inventoryReceiptRepo: Repository<InventoryReceipt>,

    @InjectRepository(InventoryReceiptItem)
    private readonly inventoryReceiptItemRepo: Repository<InventoryReceiptItem>,

    @InjectRepository(Supplier)
    private readonly supplierRepo: Repository<Supplier>,
  ) { }

  /** 🧩 Helper: map DTO → entity (chuẩn hoá key & nullable fields) */
  private mapDtoToEntity(dto: Partial<CreateProductDto>): Partial<Product> {
    const patch: Partial<Product> = {
      productName: dto.product_name,
      shortDescription: dto.short_description ?? null,
      longDescription: dto.long_description ?? null,
      status: dto.status ?? 1,
      origin: dto.origin ?? null,
      userManual:
        dto.user_manual !== undefined
          ? normalizeUserManual(dto.user_manual)
          : null,
      cautionNotes: Array.isArray(dto.caution_notes) ? dto.caution_notes : [],
    };

    if (dto.category_id !== undefined) {
      patch.category = dto.category_id
        ? ({ categoryId: dto.category_id } as any)
        : null;
    }
    return patch;
  }

  /** 🆕 Tạo mới sản phẩm (kèm ảnh, biến thể, giá, tồn kho ban đầu & phiếu nhập nếu có) */
  async create(createProductDto: CreateProductDto): Promise<Product> {
    const { images, variants, category_id, initialReceipt } = createProductDto;
    console.log(
      'initialReceipt in ProductService.create:',
      JSON.stringify(initialReceipt, null, 2),
    );

    // 1️⃣ Category (giữ như bạn viết)
    let category: Category | null = null;
    if (category_id) {
      category = await this.categoryRepo.findOne({
        where: { categoryId: category_id },
      });
      if (!category) {
        throw new NotFoundException(
          `Category với ID ${category_id} không tồn tại`,
        );
      }
    }

    // 2️⃣ Product
    const productEntity = this.productRepo.create({
      ...this.mapDtoToEntity(createProductDto),
      category,
    });
    const savedProduct = await this.productRepo.save(productEntity);

    // 3️⃣ Ảnh sản phẩm (giữ nguyên)
    if (images?.length) {
      const imageEntities = images.map((img) =>
        this.imageRepo.create({ ...img, product: savedProduct }),
      );
      await this.imageRepo.save(imageEntities);
    }

    // 4️⃣ Biến thể + giá (giữ logic mới dùng mảng)
    let variantEntities: ProductVariant[] = [];

    if (variants?.length) {
      const variantData: Partial<ProductVariant>[] = (variants as any[]).map(
        (v) => ({
          ...v,
          attributes: toObject(v.attributes),
          specs: sortSpecs(toSpecArray((v as any).specs)),
          product: savedProduct,
        }),
      );

      variantEntities = this.variantRepo.create(variantData);
      await this.variantRepo.save(variantEntities);

      const priceEntities: ProductVariantPrice[] = [];

      variants.forEach((v: any, idx) => {
        const variant = variantEntities[idx];

        if (Array.isArray(v.prices) && v.prices.length > 0) {
          v.prices.forEach((p: CreateVariantPriceDto) => {
            priceEntities.push(
              this.productVariantPriceRepo.create({
                variant,
                priceType: p.priceType,
                price: p.price,
                currencyCode: p.currencyCode ?? 'VND',
                startAt: p.startAt ?? new Date(),
                endAt: p.endAt ?? null,
              }),
            );
          });
        }
      });

      if (priceEntities.length > 0) {
        await this.productVariantPriceRepo.save(priceEntities);
      }
    }

    // 5️⃣ Tồn kho + phiếu nhập – GIỮ logic hiện tại, chỉ dùng `initialReceipt` từ DTO
    if (
      initialReceipt &&
      Array.isArray(initialReceipt.items) &&
      initialReceipt.items.length > 0
    ) {
      // 5️⃣ Tạo tồn kho + phiếu nhập ban đầu (nếu FE có truyền initialReceipt)

      // Lấy initialReceipt từ body (có thể là object hoặc string JSON)
      let initialReceipt: InitialReceiptInput | undefined = (createProductDto as any).initialReceipt;

      if (typeof initialReceipt === 'string') {
        try {
          initialReceipt = JSON.parse(initialReceipt);
          console.log('>>> [DEBUG] initialReceipt parsed from string:', initialReceipt);
        } catch (e) {
          console.warn('>>> [WARN] initialReceipt parse failed, skip inventory block:', e);
          initialReceipt = undefined;
        }
      } else {
        console.log('>>> [DEBUG] initialReceipt as object:', initialReceipt);
      }

      if (
        initialReceipt &&
        Array.isArray(initialReceipt.items) &&
        initialReceipt.items.length > 0
      ) {
        console.log('>>> [DEBUG] START inventory block, items =', initialReceipt.items.length);

        // 5.1 Validate cơ bản
        initialReceipt.items.forEach((item, idx) => {
          if (!item.quantity || item.quantity <= 0) {
            throw new BadRequestException(
              `initialReceipt.items[${idx}]: quantity phải > 0`,
            );
          }
          if (item.unitCost == null || item.unitCost < 0) {
            throw new BadRequestException(
              `initialReceipt.items[${idx}]: unitCost không hợp lệ`,
            );
          }
        });

        if (!variantEntities.length) {
          throw new BadRequestException(
            'initialReceipt được truyền nhưng sản phẩm không có variants để nhập kho',
          );
        }

        // 5.2 Map variant theo id/sku để dễ tra
        const variantById = new Map<number, ProductVariant>();
        const variantBySku = new Map<string, ProductVariant>();

        for (const v of variantEntities) {
          variantById.set(v.variantId, v);
          if (v.sku) {
            variantBySku.set(v.sku, v);
          }
        }

        console.log('>>> [DEBUG] variantById size =', variantById.size);
        console.log('>>> [DEBUG] variantBySku keys =', Array.from(variantBySku.keys()));

        // 5.3 Lấy / tạo nhà cung cấp
        let supplier: Supplier | null = null;

        if (initialReceipt.supplierId) {
          supplier = await this.supplierRepo.findOne({
            where: { supplierId: initialReceipt.supplierId },
          });
          console.log('>>> [DEBUG] supplier by ID =', supplier);
          if (!supplier) {
            throw new NotFoundException(
              `Không tìm thấy nhà cung cấp #${initialReceipt.supplierId}`,
            );
          }
        } else if (initialReceipt.supplierName) {
          supplier = this.supplierRepo.create({
            supplierName: initialReceipt.supplierName,
            phone: initialReceipt.supplierPhone ?? null,
            email: initialReceipt.supplierEmail ?? null,
            address: initialReceipt.supplierAddress ?? null,
            note: initialReceipt.supplierNote ?? null,
          });
          supplier = await this.supplierRepo.save(supplier);
          console.log('>>> [DEBUG] supplier created =', supplier);
        }

        if (!supplier) {
          throw new BadRequestException(
            'Thiếu supplierId hoặc supplierName trong initialReceipt',
          );
        }

        // 5.4 Tính tổng tiền phiếu nhập
        const totalAmount = initialReceipt.items.reduce(
          (sum, it) => sum + Number(it.quantity) * Number(it.unitCost),
          0,
        );
        console.log('>>> [DEBUG] totalAmount =', totalAmount);

        // 5.5 Tạo phiếu nhập (inventory_receipts)
        const receiptEntity = this.inventoryReceiptRepo.create({
          receiptCode:
            initialReceipt.receiptCode ?? `PNK-${Date.now()}`,
          receiptDate:
            initialReceipt.receiptDate ??
            new Date().toISOString().slice(0, 10), // 'YYYY-MM-DD'
          supplierId: supplier.supplierId,
          referenceNo: initialReceipt.referenceNo ?? null,
          note: initialReceipt.note ?? null,
          totalAmount,
        });
        const savedReceipt =
          await this.inventoryReceiptRepo.save(receiptEntity);
        console.log('>>> [DEBUG] receipt saved =', savedReceipt);

        // 5.6 Tạo dòng chi tiết + cập nhật tồn kho
        const receiptItems: InventoryReceiptItem[] = [];

        for (const [idx, item] of initialReceipt.items.entries()) {
          let variantId = item.variantId;

          // Ưu tiên variantId, nếu không có thì map theo sku
          if (!variantId && item.variantSku) {
            const v = variantBySku.get(item.variantSku);
            console.log(
              `>>> [DEBUG] map variantSku=${item.variantSku} ->`,
              v?.variantId,
            );
            if (v) {
              variantId = v.variantId;
            }
          }

          if (!variantId || !variantById.get(variantId)) {
            console.warn(
              `>>> [WARN] initialReceipt.items[${idx}]: không xác định được variant (variantId=${item.variantId}, variantSku=${item.variantSku})`,
            );
            continue; // tạm bỏ qua item lỗi để không chặn cả phiếu
          }

          // Cập nhật tồn kho product_variant_inventory
          let inv = await this.variantInventoryRepo.findOne({
            where: { variant_id: variantId },
          });

          if (!inv) {
            inv = this.variantInventoryRepo.create({
              variant_id: variantId,
              stock_quantity: 0,
              safety_stock: 0,
            });
          }

          inv.stock_quantity =
            Number(inv.stock_quantity ?? 0) + Number(item.quantity);
          inv.updated_at = new Date();
          inv = await this.variantInventoryRepo.save(inv);
          console.log('>>> [DEBUG] inventory updated =', inv);

          // Tạo dòng chi tiết phiếu nhập
          const lineTotal =
            Number(item.quantity) * Number(item.unitCost);

          const itemEntity = this.inventoryReceiptItemRepo.create({
            receiptId: savedReceipt.receiptId,
            variantId,
            quantity: item.quantity,
            unitCost: item.unitCost,
            lineTotal,
          });

          receiptItems.push(itemEntity);
        }

        console.log(
          '>>> [DEBUG] num receiptItems to save =',
          receiptItems.length,
        );

        if (receiptItems.length > 0) {
          await this.inventoryReceiptItemRepo.save(receiptItems);
          console.log('>>> [DEBUG] receiptItems saved');
        } else {
          console.warn(
            '>>> [WARN] Không có receiptItems hợp lệ nào được tạo – kiểm tra lại variantSku/variantId',
          );
        }
      } else {
        console.log(
          '>>> [DEBUG] initialReceipt EMPTY or no items – bỏ qua block tồn kho',
        );
      }

    }

    return (await this.findOne(savedProduct.productId))!;
  }


  /** ✏️ Cập nhật */
  async update(id: number, dto: Partial<CreateProductDto>): Promise<Product> {
    const existing = await this.productRepo.findOne({
      where: { productId: id },
    });
    if (!existing) throw new NotFoundException(`Product ${id} không tồn tại`);

    const patch = this.mapDtoToEntity(dto);
    await this.productRepo.update(id, patch);
    return (await this.findOne(id))!;
  }

  /** 🗑️ Xoá */
  async remove(id: number): Promise<void> {
    const existing = await this.productRepo.findOne({
      where: { productId: id },
    });
    if (!existing) throw new NotFoundException(`Product ${id} không tồn tại`);
    await this.productRepo.delete(id);
  }

  /**
   * 🔍 Lấy thông tin 1 sản phẩm CHI TIẾT:
   * - product + category + images
   * - variants (đủ trường, chuẩn hoá attributes/specs)
   * - variant.prices (toàn bộ lịch sử giá) + currentPrice tính sẵn
   */
  /**
   * 🔍 Lấy thông tin 1 sản phẩm CHI TIẾT:
   * - product + category + images
   * - variants (đủ trường, chuẩn hoá attributes/specs)
   * - variant.prices (toàn bộ lịch sử giá) + currentPrice tính sẵn
   */
  async findOne(id: number): Promise<Product | null> {
    const product = await this.productRepo.findOne({
      where: { productId: id },
      relations: ['category', 'images', 'variants', 'variants.prices'],
    });

    if (!product) return null;

    // --------- Chuẩn hoá JSONB cấp Product ---------
    // cautionNotes: luôn là array
    // @ts-ignore
    product.cautionNotes = toArray((product as any).cautionNotes);

    // userManual: luôn về dạng { pdf?, video?, steps: string[] } | null
    // @ts-ignore
    product.userManual = normalizeUserManual((product as any).userManual);

    // Không có variants thì trả luôn
    if (!product.variants || product.variants.length === 0) {
      return product;
    }

    // --------- Chuẩn hoá từng variant + gắn prices ---------
    product.variants = product.variants.map((variant: any) => {
      // attributes: JSONB → object
      const normalizedAttrs = toObject(variant.attributes);

      // specs: JSONB → SpecItem[] + sort theo order
      const normalizedSpecs = sortSpecs(toSpecArray(variant.specs));

      // prices: load từ quan hệ, chuẩn hoá & sort theo startAt desc
      const rawPrices = toArray<any>(variant.prices);
      const allPrices = rawPrices
        .map((p) => ({
          priceId: p.priceId,
          priceType: p.priceType,          // 'base' | 'promo' | 'retail' | 'sale'...
          currencyCode: p.currencyCode,
          price: Number(p.price),
          startAt: p.startAt,
          endAt: p.endAt,
          createdAt: p.createdAt,
        }))
        .sort((a, b) => {
          const ta = a.startAt ? new Date(a.startAt).getTime() : 0;
          const tb = b.startAt ? new Date(b.startAt).getTime() : 0;
          return tb - ta; // mới nhất trước
        });

      // currentPrice: dùng helper ưu tiên sale → promo → retail → base
      const cur = pickCurrentPrice(allPrices);

      return {
        ...variant,
        attributes: normalizedAttrs,
        specs: normalizedSpecs,
        prices: allPrices,                    // 👈 toàn bộ lịch sử giá
        currentPrice: cur?.price ?? null,     // 👈 giá đang áp dụng
        currentPriceType: cur?.priceType ?? null,
        currency: cur?.currencyCode ?? 'VND',
      };
    });

    return product;
  }


  /** 📄 Phân trang (nhẹ): product + category + variants + prices (current) */
  async findAllPaginated(
    page = 1,
    limit = 10,
  ): Promise<{ items: Product[]; total: number; pages: number }> {
    const [items, total] = await this.productRepo.findAndCount({
      relations: ['category', 'variants', 'images'],
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    const variantIds: number[] = items.flatMap((p: any) =>
      (p.variants || []).map((v: any) => v.id || v.variantId),
    );

    if (variantIds.length === 0) {
      const normalized = items.map((p: any) => ({
        ...p,
        cautionNotes: Array.isArray(p.cautionNotes) ? p.cautionNotes : [],
        userManual: normalizeUserManual(p.userManual),
        variants: (p.variants || []).map((v: any) => ({
          ...v,
          attributes:
            typeof v.attributes === 'object' && !Array.isArray(v.attributes)
              ? v.attributes
              : {},
          specs: Array.isArray(v.specs) ? v.specs : [],
        })),
        priceRange: null,
      }));
      return {
        items: normalized as any,
        total,
        pages: Math.ceil(total / limit),
      };
    }

    const now = new Date();
    const priceRows = await this.productVariantPriceRepo
      .createQueryBuilder('pvp')
      .select([
        '"pvp"."variant_id"    AS "variantId"',
        '"pvp"."price_id"      AS "priceId"',
        '"pvp"."price_type"    AS "priceType"',
        '"pvp"."currency_code" AS "currencyCode"',
        '"pvp"."price"         AS "price"',
        '"pvp"."start_at"      AS "startAt"',
        '"pvp"."end_at"        AS "endAt"',
        '"pvp"."created_at"    AS "createdAt"',
      ])
      .where('"pvp"."variant_id" IN (:...variantIds)', { variantIds })
      .orderBy('"pvp"."variant_id"', 'ASC')
      .addOrderBy('"pvp"."start_at"', 'ASC')
      .addOrderBy('"pvp"."created_at"', 'ASC')
      .getRawMany<{
        variantId: number;
        priceId: number;
        priceType: string;
        currencyCode: string;
        price: string | number;
        startAt: Date;
        endAt: Date | null;
        createdAt: Date;
      }>();

    type PriceDto = {
      priceId: number;
      priceType: string;
      currencyCode: string;
      price: number;
      startAt: Date;
      endAt: Date | null;
      createdAt: Date;
    };

    const pricesByVariant = new Map<number, PriceDto[]>();

    for (const row of priceRows) {
      const arr = pricesByVariant.get(row.variantId) ?? [];
      arr.push({
        priceId: row.priceId,
        priceType: row.priceType,
        currencyCode: row.currencyCode,
        price: Number(row.price),
        startAt: row.startAt,
        endAt: row.endAt,
        createdAt: row.createdAt,
      });
      pricesByVariant.set(row.variantId, arr);
    }

    const nowMs = now.getTime();

    const normalized = items.map((p: any) => {
      p.cautionNotes = Array.isArray(p.cautionNotes) ? p.cautionNotes : [];
      p.userManual = normalizeUserManual(p.userManual);

      p.variants = (p.variants || []).map((v: any) => {
        const variantId = v.id || v.variantId;
        const prices = pricesByVariant.get(variantId) || [];

        // (tuỳ chọn) xác định giá đang hiệu lực để hiển thị
        let active: PriceDto | null = null;
        for (const pr of prices) {
          const start = pr.startAt ? pr.startAt.getTime() : -Infinity;
          const end = pr.endAt ? pr.endAt.getTime() : Infinity;
          if (start <= nowMs && nowMs < end) {
            if (!active || pr.startAt > active.startAt) {
              active = pr;
            }
          }
        }

        return {
          ...v,
          attributes:
            typeof v.attributes === 'object' && !Array.isArray(v.attributes)
              ? v.attributes
              : {},
          specs: Array.isArray(v.specs) ? v.specs : [],
          prices,
          // nếu muốn đẩy luôn giá active ra FE:
          // currentPrice: active?.price ?? null,
          // currentPriceType: active?.priceType ?? null,
          // currency: active?.currencyCode ?? 'VND',
        };
      });

      return p;
    });

    return {
      items: normalized as any,
      total,
      pages: Math.ceil(total / limit),
    };
  }

  /** 🔎 Tìm kiếm full-text (giữ nguyên) */
  async searchProducts(q: string, page = 1, limit = 10) {
    const term = (q ?? '').trim();
    if (!term)
      return { items: [], pagination: { page, limit, total: 0, pages: 0 } };

    const offset = (page - 1) * limit;

    const items = await this.ds.query(
      `
      WITH q AS (
        SELECT public.unaccent_imm($1) AS uq,
               websearch_to_tsquery('pg_catalog.simple', public.unaccent_imm($1))

      )
      SELECT
        p.product_id,
        p.product_name,
        ts_rank_cd(p.search_vec, q.tsq, 32) AS rank,
        img.image_url AS image_url
      FROM public.products p
      CROSS JOIN q
      LEFT JOIN LATERAL (
        SELECT pi.image_url
        FROM public.product_images pi
        WHERE pi.product_id = p.product_id
        ORDER BY pi.is_primary DESC, pi.image_id ASC
        LIMIT 1
      ) AS img ON TRUE
      WHERE (p.search_vec @@ q.tsq)
         OR public.unaccent_imm(p.product_name) ILIKE '%' || q.uq || '%'
      ORDER BY rank DESC, p.product_id
      LIMIT $2 OFFSET $3
      `,
      [term, limit, offset],
    );

    const totalRes = await this.ds.query(
      `
  WITH q AS (
    SELECT public.unaccent_imm($1) AS uq,
           websearch_to_tsquery('pg_catalog.simple', public.unaccent_imm($1)) AS tsq
  )
  SELECT COUNT(*)::int AS count
  FROM public.products p, q
  WHERE (p.search_vec @@ q.tsq)
     OR public.unaccent_imm(p.product_name) ILIKE '%' || q.uq || '%'
  `,
      [term],
    );


    const total: number = totalRes?.[0]?.count ?? 0;

    return {
      items,
      pagination: { page, limit, total, pages: Math.ceil(total / limit) },
    };
  }
}
