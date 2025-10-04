import { Controller, Post, Body, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './login.dto';
import { RegisterDto } from './register.dto';
import { Public } from './public.decorator';
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) { }
  @Public()
  @Post('login')
  async login(@Body() body: LoginDto) {
    console.log(body);
    const user = await this.authService.validateUser(body.email, body.password);
    if (!user) {
      throw new UnauthorizedException('Invalid username or password');
    }

    return this.authService.login(user);
  }
  @Public()
  @Post('register')
  async register(@Body() body: RegisterDto) {
    const user = await this.authService.register(body);
    return { message: 'User created', user };
  }
}
