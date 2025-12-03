import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Banner } from './entities/banner.entity';
import { CreateBannerDto } from './dto/create-banner.dto';
import { UpdateBannerDto } from './dto/update-banner.dto';
import * as fs from 'fs';
import * as path from 'path';
@Injectable()
export class BannerService {
    constructor(
        @InjectRepository(Banner)
        private repo: Repository<Banner>,
    ) { }

    create(dto: CreateBannerDto) {
        const banner = this.repo.create(dto);
        return this.repo.save(banner);
    }

    findAll() {
        return this.repo.find({
            order: { created_at: 'DESC' },
        });
    }

    async findOne(id: number) {
        const banner = await this.repo.findOne({ where: { id } });
        if (!banner) throw new NotFoundException('Banner not found');
        return banner;
    }
    async update(id: number, dto: UpdateBannerDto, file?: Express.Multer.File) {
        const banner = await this.repo.findOne({ where: { id } });

        if (!banner) {
            throw new NotFoundException('Banner not found');
        }

        // Nếu có ảnh mới → xóa ảnh cũ + gán ảnh mới
        if (file) {
            if (banner.imageUrl) {
                const oldPath = path.join(
                    process.cwd(),
                    'public',
                    'uploads',
                    path.basename(banner.imageUrl)
                );

                // Xóa ảnh cũ nếu tồn tại
                if (fs.existsSync(oldPath)) {
                    fs.unlinkSync(oldPath);
                }
            }

            // Gán ảnh mới
            banner.imageUrl = `/uploads/${file.filename}`;
        }

        // Gán các trường khác (nếu có)
        Object.assign(banner, dto);

        return this.repo.save(banner);
    }

    async remove(id: number) {
        const banner = await this.findOne(id);
        return this.repo.remove(banner);
    }
}
