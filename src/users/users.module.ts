import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { User } from './entities/user.entity';
import { Cart } from 'src/cart/entities/cart.entity';
import { Address } from './entities/address.entity';
import { UserProfileIndividual } from './entities/user_profile_individual.entity';
import { UserProfileBusiness } from './entities/user_profile_business.entity';
import { UsersController } from './users.controller';
import { EmailQueueModule } from 'src/email/email.queue.module';
import { Role } from '../role/entities/role.entity';
import { RolesModule } from 'src/role/roles.module';
import { UserPermission } from './entities/user-permission.entity';

@Module({
  imports: [TypeOrmModule.forFeature([
    User,
    Cart,
    Address,
    UserProfileBusiness,
    UserProfileIndividual,
    UserPermission,
  ]),
    EmailQueueModule,
    RolesModule
  ],

  providers: [UsersService],
  exports: [UsersService],
  controllers: [UsersController],
})
export class UsersModule { }
