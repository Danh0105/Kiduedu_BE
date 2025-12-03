import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductVariantInventory } from '../entities/product-variant-inventory.entity';
import { UpdateVariantInventoryDto } from '../dto/update-variant-inventory.dto';

@Injectable()
export class ProductVariantInventoryService {
    constructor(
        @InjectRepository(ProductVariantInventory)
        private readonly repo: Repository<ProductVariantInventory>,
    ) { }

    /**
     * 🔍 Lấy thông tin tồn kho của 1 variant
     */
    async getInventory(variantId: number) {
        const inv = await this.repo.findOne({ where: { variantId: variantId } });
        if (!inv) {
            throw new NotFoundException(`Inventory not found for variant ${variantId}`);
        }
        return inv;
    }

    /**
     * 🧮 Cập nhật tồn kho (tăng/giảm hoặc set giá trị mới)
     * Nếu chưa tồn tại → tự động tạo mới
     */
    async updateInventory(variantId: number, dto: UpdateVariantInventoryDto) {
        let inventory = await this.repo.findOne({ where: { variantId: variantId } });

        if (!inventory) {
            // Nếu chưa có bản ghi tồn kho thì tạo mới
            inventory = this.repo.create({
                variantId: variantId,
                stock_quantity: dto.stock_quantity ?? 0,
                safety_stock: dto.safety_stock ?? 0,
                updated_at: new Date(),
            });
        } else {
            // Nếu đã có thì cập nhật
            inventory.stock_quantity = dto.stock_quantity;
            inventory.safety_stock = dto.safety_stock;
            inventory.updated_at = new Date();
        }

        await this.repo.save(inventory);
        return inventory;
    }
}
