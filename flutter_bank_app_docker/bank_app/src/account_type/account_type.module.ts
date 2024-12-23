import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UtilsModule } from '../utils/utils.module';
import { AccountTypeController } from './account_type.controller';
import { Accounts_type } from './account_type.entity';
import { AccountTypeService } from './account_type.service';

@Module({
  imports: [UtilsModule, TypeOrmModule.forFeature([Accounts_type])],
  controllers: [AccountTypeController],
  providers: [AccountTypeService],
})
export class AccountTypeModule {}
