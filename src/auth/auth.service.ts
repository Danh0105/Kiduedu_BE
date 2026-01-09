import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import * as bcrypt from 'bcryptjs';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) { }

  async validateUser(email: string, password: string): Promise<any> {
    const user = await this.usersService.findByEmail(email);
    console.log(" user:", user);

    if (!user) return null;

    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) return null;

    const { password_hash, ...safeUser } = user;
    return safeUser;
  }


  async login(user: any) {
    const permissions =
      user.role && user.role.permissions
        ? user.role.permissions.map(p => p.code)
        : [];
    const payload = {
      sub: user.user_id,
      email: user.email,
      role: {
        id: user.role.id,
        name: user.role.name,
      },
      permissions,
    };

    return {
      access_token: this.jwtService.sign(payload),
    };
  }


  async register(data: any) {
    return this.usersService.createUser(data);
  }
}


