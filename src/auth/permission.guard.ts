import {
    Injectable,
    CanActivate,
    ExecutionContext,
    ForbiddenException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PERMISSIONS_KEY } from './permissions.decorator';

@Injectable()
export class PermissionGuard implements CanActivate {
    constructor(private reflector: Reflector) { }

    canActivate(context: ExecutionContext): boolean {
        const requiredPermissions =
            this.reflector.getAllAndOverride<string[]>(
                PERMISSIONS_KEY,
                [context.getHandler(), context.getClass()],
            );

        // Không yêu cầu permission → cho qua
        if (!requiredPermissions || requiredPermissions.length === 0) {
            return true;
        }

        const request = context.switchToHttp().getRequest();
        const user = request.user;

        if (!user || !Array.isArray(user.permissions)) {
            throw new ForbiddenException('Không có quyền truy cập');
        }

        const hasPermission = requiredPermissions.every((p) =>
            user.permissions.includes(p),
        );

        if (!hasPermission) {
            throw new ForbiddenException('Thiếu quyền thao tác');
        }

        return true;
    }
}
