import { Controller, Post, Body, BadRequestException, Get, Query, Res, HttpCode, HttpStatus, UseGuards, Delete, Param, ParseIntPipe, Req, Patch } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { CustomerType } from './entities/user.entity';
import { CreateUserAdminDto } from './dto/create-user-admin';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { RolesGuard } from 'src/auth/roles.guard';
import { Roles } from 'src/auth/roles.decorator';
import { Permissions } from 'src/auth/permissions.decorator';

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

  /*  @Get("verify-email")
   async verifyEmail(@Query("token") token: string, @Res() res: Response) {
     try {
       await this.usersService.verifyEmail(token);
       return res.redirect("https://www.kidoedu.edu.vn/verify-success");
     } catch (err) {
       return res.redirect("https://www.kidoedu.edu.vn/verify-failed");
     }
   } */

  @Get("check-verify")
  async checkVerify(@Query("email") email: string) {
    const user = await this.usersService.findByEmail(email);
    return { verified: user?.emailVerified ?? false };
  }
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Get('permissions')
  async getUsersWithPermissions() {
    return this.usersService.findUsersWithPermissions();
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Get(':id/permissions')
  getUserPermissions(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.usersService.getEffectivePermissions(id);
  }
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Post(':id/permissions')
  grantUserPermissions(
    @Param('id', ParseIntPipe) id: number,
    @Body('permissionIds') permissionIds: number[],
  ) {
    return this.usersService.grantUserPermissions(id, permissionIds);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Delete(':id/permissions')
  revokeUserPermissions(
    @Param('id', ParseIntPipe) id: number,
    @Body('permissionIds') permissionIds: number[],
  ) {
    return this.usersService.revokeUserPermissions(id, permissionIds);
  }


  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Get()
  async getAllUsers() {
    return this.usersService.findAllPaginated();
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Permissions('user.create')
  @Post()
  @HttpCode(HttpStatus.CREATED)
  async createUserByAdmin(@Body() dto: CreateUserAdminDto) {
    return this.usersService.createAdmin(dto);
  }
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Delete(':id')
  async deleteUser(
    @Param('id', ParseIntPipe) id: number,
    @Req() req: any,
  ) {
    const adminId = req.user.sub || req.user.user_id;
    return this.usersService.deleteUserByAdmin(id, adminId);
  }
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Patch(':id')
  updateUserRole(
    @Param('id', ParseIntPipe) id: number,
    @Body('roleId') roleId: number,
  ) {
    return this.usersService.updateUserRole(id, roleId);
  }

}
