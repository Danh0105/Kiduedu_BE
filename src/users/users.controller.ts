import { Controller, Post, Body, BadRequestException, Get, Query, Res } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { CustomerType } from './entities/user.entity';
import type { Response } from 'express';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) { }

  /**
   * API chung: Đăng ký user (cá nhân hoặc doanh nghiệp)
   * - Nếu không truyền customerType => mặc định là cá nhân
   */
  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    if (!createUserDto.email || !createUserDto.username) {
      throw new BadRequestException('Thiếu thông tin bắt buộc: email hoặc username');
    }
    return this.usersService.createUser(createUserDto);
  }

  /**
   * API đăng ký doanh nghiệp
   * - Tự động set customerType = BUSINESS
   */
  @Post('register-business')
  async registerBusiness(@Body() createUserDto: CreateUserDto) {
    return this.usersService.createUser({
      ...createUserDto,
      customerType: CustomerType.BUSINESS,
    });
  }

  /**
   * API đăng ký cá nhân
   * - Tự động set customerType = INDIVIDUAL
   */
  @Post('register-individual')
  async registerIndividual(@Body() createUserDto: CreateUserDto) {
    return this.usersService.createUser({
      ...createUserDto,
      customerType: CustomerType.INDIVIDUAL,
    });
  }

  @Get("verify-email")
  async verifyEmail(@Query("token") token: string, @Res() res: Response) {
    try {
      await this.usersService.verifyEmail(token);
      return res.redirect("https://www.kidoedu.edu.vn/verify-success");
    } catch (err) {
      return res.redirect("https://www.kidoedu.edu.vn/verify-failed");
    }
  }

  @Get("check-verify")
  async checkVerify(@Query("email") email: string) {
    const user = await this.usersService.findByEmail(email);
    return { verified: user?.emailVerified ?? false };
  }

}
