import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Setting } from '../entities/setting-email.entity';

@Injectable()
export class SettingsService {
    constructor(
        @InjectRepository(Setting)
        private readonly settingsRepo: Repository<Setting>,
    ) { }

    async getAll(): Promise<Setting[]> {
        return this.settingsRepo.find({ order: { key: 'ASC' } });
    }

    async get(key: string): Promise<string | null> {
        const item = await this.settingsRepo.findOne({ where: { key } });
        return item?.value ?? null;
    }

    async getEntity(key: string): Promise<Setting | null> {
        return this.settingsRepo.findOne({ where: { key } });
    }

    async set(key: string, value: string): Promise<Setting> {
        let item = await this.settingsRepo.findOne({ where: { key } });
        if (!item) {
            item = this.settingsRepo.create({ key, value });
        } else {
            item.value = value;
        }
        return this.settingsRepo.save(item);
    }

    async remove(key: string): Promise<void> {
        const item = await this.settingsRepo.findOne({ where: { key } });
        if (!item) throw new NotFoundException('Setting not found');
        await this.settingsRepo.remove(item);
    }
}
