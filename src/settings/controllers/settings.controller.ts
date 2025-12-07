import { Controller, Get, Param, Put, Body, HttpCode, UseGuards } from '@nestjs/common';
import { SettingsService } from '../services/setting-email.service';
import { Setting } from '../entities/setting-email.entity';

// TODO: Add proper auth guard for admin access
@Controller('settings')
export class SettingsController {
    constructor(private readonly settingsService: SettingsService) { }

    @Get()
    async findAll(): Promise<Setting[]> {
        return this.settingsService.getAll();
    }

    @Get(':key')
    async findOne(@Param('key') key: string): Promise<{ key: string; value: string | null }> {
        const v = await this.settingsService.get(key);
        return { key, value: v };
    }

    @Put(':key')
    @HttpCode(200)
    async upsert(@Param('key') key: string, @Body('value') value: string): Promise<Setting> {
        // You may want to validate keys allowed
        return this.settingsService.set(key, value);
    }
}
