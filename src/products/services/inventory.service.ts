import {
    Injectable,
    BadRequestException,
    NotFoundException,
} from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { DataSource, Repository } from "typeorm";

import { InventoryReceipt } from "../entities/inventory-receipt.entity";
import { InventoryReceiptItem } from "../entities/inventory-receipt-item.entity";
import { ProductVariantInventory } from "../entities/product-variant-inventory.entity";

@Injectable()
export class InventoryService {
    constructor(
        @InjectRepository(InventoryReceipt)
        private receiptRepo: Repository<InventoryReceipt>,

        @InjectRepository(InventoryReceiptItem)
        private itemRepo: Repository<InventoryReceiptItem>,

        @InjectRepository(ProductVariantInventory)
        private inventoryRepo: Repository<ProductVariantInventory>,

        private dataSource: DataSource
    ) { }

    /* ======================================================
                AUTO GENERATE RECEIPT CODE (PNK / PXK)
    ====================================================== */
    async generateCode(type: string) {
        const prefix = type === "import" ? "PNK" : "PXK";

        const last = await this.receiptRepo.find({
            order: { receiptId: "DESC" },
            take: 1,
        });

        const nextId = last.length ? last[0].receiptId + 1 : 1;

        return `${prefix}${String(nextId).padStart(4, "0")}`;
    }

    /* ======================================================
                     UPDATE STOCK (SAFE METHOD)
        quantity > 0  => import
        quantity < 0  => export
    ====================================================== */
    async adjustStock(variantId: number, quantity: number) {
        let row = await this.inventoryRepo.findOne({
            where: { variantId },
        });

        if (!row) {
            row = this.inventoryRepo.create({
                variantId,
                stock_quantity: 0,
                safety_stock: 0,
            });
        }

        const newStock = row.stock_quantity + quantity;
        const newSafety = row.safety_stock + quantity;

        if (newStock < 0 || newSafety < 0) {
            throw new BadRequestException(
                `Biến thể ${variantId} không đủ tồn kho hoặc safety stock!`
            );
        }

        row.stock_quantity = newStock;
        row.safety_stock = newSafety;
        row.updated_at = new Date();

        await this.inventoryRepo.save(row);
    }

    /* ======================================================
                     CREATE IMPORT / EXPORT RECEIPT
    ====================================================== */
    async create(dto: any) {
        const { type, date, supplierId, note, referenceNo, items } = dto;

        if (!items || items.length === 0) {
            throw new BadRequestException(
                "Phiếu phải có ít nhất 1 sản phẩm."
            );
        }

        return this.dataSource.transaction(async (manager) => {
            // 1) Create receipt
            const receipt = manager.create(InventoryReceipt, {
                receiptCode: await this.generateCode(type),
                receiptDate: date,
                supplierId: type === "import" ? supplierId : null,
                referenceNo: referenceNo || null,
                note: note || null,
                totalAmount: 0,
            });

            const savedReceipt = await manager.save(receipt);

            let totalAmount = 0;

            // 2) Save each item
            for (const item of items) {
                const quantity = Number(item.quantity);
                const unitCost = Number(item.unitCost || 0);
                const lineTotal = quantity * unitCost;

                const record = manager.create(InventoryReceiptItem, {
                    receiptId: savedReceipt.receiptId,
                    variantId: item.variantId,
                    quantity: quantity,
                    unitCost: unitCost,
                    lineTotal: lineTotal,
                });

                await manager.save(record);

                totalAmount += lineTotal;

                /* ==========================================
                    3) Update Stock + Safety Stock
                ========================================== */

                // Xác định số tăng/giảm
                const delta = type === "import" ? quantity : -quantity;

                // Kiểm tra tồn kho trước khi cập nhật
                const current = await manager.query(
                    `SELECT stock_quantity, safety_stock 
                        FROM product_variant_inventory 
                        WHERE variant_id = $1`,
                    [item.variantId]
                );

                // ===============================
                // CASE 1 - CHƯA TỪNG CÓ TỒN KHO
                // ===============================
                if (!current.length) {
                    if (delta < 0) {
                        throw new BadRequestException(
                            `Biến thể ${item.variantId} chưa có tồn kho, không thể xuất!`
                        );
                    }

                    // Nhập kho lần đầu
                    await manager.query(
                        `
                        INSERT INTO product_variant_inventory 
                            (variant_id, stock_quantity, safety_stock)
                        VALUES ($1, $2, $2)
                        `,
                        [item.variantId, delta]
                    );
                }
                // ===============================
                // CASE 2 - ĐÃ CÓ TỒN KHO
                // ===============================
                else {
                    const newStock = Number(current[0].stock_quantity) + delta;
                    const newSafety = Number(current[0].safety_stock) + delta;

                    if (newStock < 0 || newSafety < 0) {
                        throw new BadRequestException(
                            `Biến thể ${item.variantId} không đủ tồn kho để xuất!`
                        );
                    }

                    await manager.query(
                        `
                        UPDATE product_variant_inventory
                        SET stock_quantity = $2,
                            safety_stock   = $3
                        WHERE variant_id = $1
                        `,
                        [item.variantId, newStock, newSafety]
                    );
                }
            }

            // 5) Update total amount
            savedReceipt.totalAmount = totalAmount;
            return manager.save(savedReceipt);
        });
    }

    /* ======================================================
                          LIST RECEIPTS
    ====================================================== */
    async findAll() {
        return this.receiptRepo.find({
            order: { receiptId: "DESC" },
            relations: ["supplier", "items"],
        });
    }

    /* ======================================================
                          RECEIPT DETAIL
    ====================================================== */
    async findOne(id: number) {
        const data = await this.receiptRepo.findOne({
            where: { receiptId: id },
            relations: ["items", "supplier"],
        });

        if (!data) {
            throw new NotFoundException("Không tìm thấy phiếu kho!");
        }

        return data;
    }

    /* ======================================================
                         DELETE RECEIPT + ROLLBACK STOCK
    ====================================================== */
    async remove(id: number) {
        const receipt = await this.findOne(id);

        // Rollback tồn kho
        for (const item of receipt.items) {
            await this.adjustStock(
                item.variantId as number,
                receipt.supplierId ? -item.quantity : item.quantity
            );
        }

        await this.itemRepo.delete({ receiptId: id });
        await this.receiptRepo.delete(id);

        return { message: "Đã xoá phiếu và phục hồi tồn kho" };
    }
}
