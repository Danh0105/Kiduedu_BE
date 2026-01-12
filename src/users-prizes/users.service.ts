import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(User)
        private readonly userRepo: Repository<User>,
    ) { }

    create(data: Partial<User>) {
        const user = this.userRepo.create(data);
        return this.userRepo.save(user);
    }

    findAll() {
        return this.userRepo.find({
            order: { createdAt: 'DESC' },
        });
    }

    findOne(id: number) {
        return this.userRepo.findOneBy({ id });
    }

    async update(id: number, data: Partial<User>) {
        const user = await this.findOne(id);
        if (!user) throw new NotFoundException('User not found');

        Object.assign(user, data);
        return this.userRepo.save(user);
    }

    async remove(id: number) {
        const user = await this.findOne(id);
        if (!user) throw new NotFoundException('User not found');

        return this.userRepo.remove(user);
    }

    async resetSpin(id: number) {
        const user = await this.findOne(id);
        if (!user) throw new NotFoundException('User not found');

        user.hasSpun = false;
        return this.userRepo.save(user);
    }

    async resetAllSpin() {
        return this.userRepo.update({}, { hasSpun: false });
    }
}
