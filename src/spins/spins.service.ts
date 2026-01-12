import {
    BadRequestException,
    Injectable,
    NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, MoreThan, Repository } from 'typeorm';
import { User } from '../users-prizes/user.entity';
import { Prize } from '../prizes/prize.entity';
import { SpinLog } from './spin-log.entity';

@Injectable()
export class SpinsService {
    constructor(
        @InjectRepository(User)
        private readonly userRepo: Repository<User>,

        @InjectRepository(Prize)
        private readonly prizeRepo: Repository<Prize>,

        @InjectRepository(SpinLog)
        private readonly spinLogRepo: Repository<SpinLog>,

        private readonly dataSource: DataSource,
    ) { }

    async spin(userId: number) {
        const user = await this.userRepo.findOne({
            where: { id: userId },
        });

        if (!user) {
            throw new NotFoundException('User không tồn tại');
        }

        if (user.hasSpun) {
            throw new BadRequestException('Bạn đã quay rồi');
        }

        const prizes = await this.prizeRepo.find({
            where: { quantity: MoreThan(0) },
        });

        if (prizes.length === 0) {
            throw new BadRequestException('Hết phần thưởng');
        }

        // ===== RANDOM THEO TỶ LỆ =====
        const totalRate = prizes.reduce(
            (sum, prize) => sum + prize.probability,
            0,
        );

        let rand = Math.random() * totalRate;
        let selectedPrize = prizes[0];

        for (const prize of prizes) {
            rand -= prize.probability;
            if (rand <= 0) {
                selectedPrize = prize;
                break;
            }
        }

        // ===== TRANSACTION CHỐNG TRÙNG =====
        await this.dataSource.transaction(async (manager) => {
            const prize = await manager.findOne(Prize, {
                where: { id: selectedPrize.id },
                lock: { mode: 'pessimistic_write' },
            });

            if (!prize || prize.quantity <= 0) {
                throw new BadRequestException('Phần thưởng đã hết');
            }

            prize.quantity -= 1;
            await manager.save(prize);

            user.hasSpun = true;
            await manager.save(user);

            await manager.save(SpinLog, {
                user,
                prize,
            });
        });

        return {
            success: true,
            prizeId: selectedPrize.id,
            prizeName: selectedPrize.name,
        };
    }
}
