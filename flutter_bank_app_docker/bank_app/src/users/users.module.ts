import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { User } from './users.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UtilsModule } from '../utils/utils.module';
import { FirebaseModule } from '../firebase/firebase.module';
import { AuthService } from '../Autentication/auth.service';

@Module({
  imports: [UtilsModule, TypeOrmModule.forFeature([User]), FirebaseModule],
  controllers: [UsersController],
  providers: [UsersService, AuthService],
  exports: [TypeOrmModule],
})
export class UsersModule {}
