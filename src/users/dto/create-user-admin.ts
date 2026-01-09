// src/users/dto/create-user.dto.ts
import {
    IsEmail,
    IsNotEmpty,
    IsString,
    MinLength,
    IsInt,
} from 'class-validator';

export class CreateUserAdminDto {
    @IsString()
    @IsNotEmpty({ message: 'Họ và tên không được để trống' })
    name: string;

    @IsEmail({}, { message: 'Email không hợp lệ' })
    @IsNotEmpty({ message: 'Email không được để trống' })
    email: string;

    @IsString()
    @MinLength(6, { message: 'Mật khẩu tối thiểu 6 ký tự' })
    password: string;

    @IsInt({ message: 'Vai trò không hợp lệ' })
    id: number;
}
