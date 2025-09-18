import * as bcrypt from 'bcryptjs';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) { }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email } });
  }

  async createUser(data: {
    username: string;
    email: string;
    password: string;
    fullName: string;
    phoneNumber: string;
    role?: string;
  }): Promise<User> {
    const password_hash = await bcrypt.hash(data.password, 10);
    const user = this.usersRepository.create({
      username: data.username,
      email: data.email,
      password_hash,
      full_name: data.fullName,
      phone_number: data.phoneNumber,
      role: data.role ?? 'customer',
    });
    return this.usersRepository.save(user);
  }
}
