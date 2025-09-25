import * as bcrypt from 'bcryptjs';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { Cart } from 'src/cart/entities/cart.entity';
import { Address } from './entities/address.entity'; // nhớ import
import { CustomerType } from './entities/user.entity';
import { UserProfileIndividual } from './entities/user_profile_individual.entity';
import { UserProfileBusiness } from './entities/user_profile_business.entity';
@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,

    @InjectRepository(Cart)
    private cartRepository: Repository<Cart>,

    @InjectRepository(Address)
    private addressRepository: Repository<Address>,

    @InjectRepository(UserProfileBusiness)
    private businessRepository: Repository<UserProfileBusiness>,

    @InjectRepository(UserProfileIndividual)
    private individualRepository: Repository<UserProfileIndividual>,
  ) { }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email } });
  }

  async createUser(data: {
    username: string;
    email: string;
    password: string;
    fullName?: string;
    phoneNumber?: string;
    role?: string;
    customerType?: CustomerType;
    companyName?: string;
    taxId?: string;
    businessEmail?: string;
    firstName?: string;
    lastName?: string;
    dateOfBirth?: Date;
    address?: {
      full_name: string;
      phone_number: string;
      street: string;
      ward: string;
      district: string;
      city: string;
      is_default?: boolean;
    };
  }): Promise<User> {
    // 1. Hash password
    const password_hash = await bcrypt.hash(data.password, 10);

    // 2. Tạo User
    const user = this.usersRepository.create({
      username: data.username,
      email: data.email,
      password_hash,
      full_name: data.fullName ?? null,
      phone_number: data.phoneNumber ?? null,
      role: data.role ?? 'customer',
      customer_type: data.customerType ?? CustomerType.INDIVIDUAL,
    } as Partial<User>);


    const savedUser = await this.usersRepository.save(user);

    // 3. Tạo Cart mặc định cho User
    const cart = this.cartRepository.create({
      user: savedUser,
    });
    await this.cartRepository.save(cart);

    // 4. Nếu có địa chỉ thì lưu Address
    if (data.address) {
      const address = this.addressRepository.create({
        ...data.address,
        user: savedUser,
      });
      await this.addressRepository.save(address);
    }
    // Nếu là doanh nghiệp thì thêm vào user_profile_business
    if (data.customerType === CustomerType.BUSINESS) {
      const businessProfile = this.businessRepository.create({
        user_id: savedUser.user_id,
        company_name: data.companyName,
        tax_id: data.taxId,
        email: data.businessEmail,
        user: savedUser,
      });
      await this.businessRepository.save(businessProfile);
    }

    // Nếu là cá nhân thì thêm vào user_profile_individual
    if (data.customerType === CustomerType.INDIVIDUAL) {
      const individualProfile = this.individualRepository.create({
        first_name: data.firstName ?? '',
        last_name: data.lastName ?? '',
        ...(data.dateOfBirth ? { date_of_birth: data.dateOfBirth } : {}), // 👈 chỉ set nếu có
        user: savedUser, // 👈 quan hệ sẽ tự map user_id
      });

      await this.individualRepository.save(individualProfile);
    }
    return savedUser;
  }
}
