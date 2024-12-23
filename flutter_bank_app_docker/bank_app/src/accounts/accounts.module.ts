import { forwardRef, Module } from '@nestjs/common';
import { AccountsController } from './accounts.controller';
import { AccountsService } from './accounts.service';
import { UtilsModule } from '../utils/utils.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Accounts } from './accounts.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Accounts]),
    UtilsModule,
  ],
  exports: [TypeOrmModule, AccountsService],
  controllers: [AccountsController],
  providers: [AccountsService],
})
export class AccountsModule {}
