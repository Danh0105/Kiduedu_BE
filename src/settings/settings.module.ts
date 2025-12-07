import { Module } from "@nestjs/common";
import { Setting } from "./entities/setting-email.entity";
import { TypeOrmModule } from "@nestjs/typeorm";
import { SettingsService } from "./services/setting-email.service";
import { SettingsController } from "./controllers/settings.controller";

@Module({
    imports: [TypeOrmModule.forFeature([Setting])],
    providers: [SettingsService],
    controllers: [SettingsController],
    exports: [SettingsService],
})
export class SettingsModule { }
