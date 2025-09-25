// users.controller.ts
import { Controller, Post, Body } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { CustomerType } from './entities/user.entity';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) { }

  // API chung: đăng ký cả cá nhân & doanh nghiệp
  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    return this.usersService.createUser(createUserDto);
  }

  // Đăng ký doanh nghiệp
  @Post('register-business')
  async registerBusiness(@Body() createUserDto: CreateUserDto) {
    return this.usersService.createUser({
      ...createUserDto,
      customerType: CustomerType.BUSINESS,
    });
  }

  // Đăng ký cá nhân
  @Post('register-individual')
  async registerIndividual(@Body() createUserDto: CreateUserDto) {
    return this.usersService.createUser({
      ...createUserDto,
      customerType: CustomerType.INDIVIDUAL,
    });
  }
}
