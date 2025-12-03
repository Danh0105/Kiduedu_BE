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
            SINH MÃ PHIẾU TỰ ĐỘNG  (PNK0001 / PXK0001)
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
                     CẬP NHẬT TỒN KHO
        quantity > 0  => nhập kho
        quantity < 0  => xuất kho
    ====================================================== */
    async adjustStock(variantId: number, quantity: number) {
        let row = await this.inventoryRepo.findOne({
            where: { variantId: variantId },
        });

        // Nếu chưa có biến thể trong tồn kho => tạo mới
        if (!row) {
            row = this.inventoryRepo.create({
                variantId: variantId,
                stock_quantity: 0,
                safety_stock: 0,
            });
        }

        const newQty = row.stock_quantity + quantity;

        if (newQty < 0) {
            throw new BadRequestException(
                `Biến thể ${variantId} không đủ tồn kho để xuất!`
            );
        }

        row.stock_quantity = newQty;
        row.updated_at = new Date();

        await this.inventoryRepo.save(row);
    }

    /* ======================================================
                     TẠO PHIẾU NHẬP / XUẤT
    ====================================================== */
    async create(dto: any) {
        const { type, date, supplierId, note, referenceNo, items } = dto;

        if (!items || items.length === 0) {
            throw new BadRequestException("Phiếu phải có ít nhất 1 sản phẩm.");
        }

        return this.dataSource.transaction(async (manager) => {
            // 1) Tạo phiếu nhập / xuất
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

            // 2) Lưu từng item
            for (const item of items) {
                const quantity = Number(item.quantity);
                const unitCost = Number(item.unitCost || 0);
                const lineTotal = quantity * unitCost;

                const record = manager.create(InventoryReceiptItem, {
                    receiptId: savedReceipt.receiptId,   // 👈 QUAN TRỌNG: CÓ receiptId
                    variantId: item.variantId,
                    quantity: quantity,
                    unitCost: unitCost,
                    lineTotal: lineTotal,
                });

                await manager.save(record); // 👈 BẮT BUỘC: lưu item độc lập

                totalAmount += lineTotal;

                // 3) Cập nhật tồn kho
                await manager.query(
                    `
                INSERT INTO product_variant_inventory (variant_id, stock_quantity, safety_stock)
                VALUES ($1, $2, 0)
                ON CONFLICT (variant_id)
                DO UPDATE SET stock_quantity =
                    product_variant_inventory.stock_quantity + EXCLUDED.stock_quantity
                `,
                    [
                        item.variantId,
                        type === "import" ? quantity : -quantity,
                    ]
                );

                // Nếu là xuất kho → kiểm tra tồn kho âm
                if (type === "export") {
                    const check = await manager.query(
                        `SELECT stock_quantity FROM product_variant_inventory WHERE variant_id = $1`,
                        [item.variantId]
                    );

                    if (!check.length || Number(check[0].stock_quantity) < 0) {
                        throw new BadRequestException(
                            `Biến thể ${item.variantId} không đủ tồn kho để xuất!`
                        );
                    }
                }
            }

            // 4) Cập nhật tổng tiền vào phiếu
            savedReceipt.totalAmount = totalAmount;
            return manager.save(savedReceipt);
        });
    }


    /* ======================================================
                        LẤY DANH SÁCH PHIẾU
    ====================================================== */
    async findAll() {
        return this.receiptRepo.find({
            order: { receiptId: "DESC" },
            relations: ["supplier", "items"],
        });
    }

    /* ======================================================
                        LẤY CHI TIẾT PHIẾU
    ====================================================== */
    async findOne(id: number) {
        const data = await this.receiptRepo.findOne({
            where: { receiptId: id },
            relations: ["items", "supplier"],
        });

        if (!data) throw new NotFoundException("Không tìm thấy phiếu kho!");

        return data;
    }

    /* ======================================================
                       XOÁ PHIẾU (ROLLBACK TỒN)
    ====================================================== */
    async remove(id: number) {
        const receipt = await this.findOne(id);

        // Rollback tồn kho
        for (const item of receipt.items) {

            await this.adjustStock(
                Number(item.variantId),
                receipt.supplierId ? -item.quantity : item.quantity
            );
        }

        await this.itemRepo.delete({ receiptId: id });
        await this.receiptRepo.delete(id);

        return { message: "Đã xoá phiếu và phục hồi tồn kho" };
    }
}
