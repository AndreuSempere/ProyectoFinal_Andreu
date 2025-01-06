import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TransactionsService } from './transactions.service';
import { TransactionsController } from './transactions.controller';
import { Transaction } from './transactions.entity';
import { Accounts } from '../accounts/accounts.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Transaction, Accounts])],
  controllers: [TransactionsController],
  providers: [TransactionsService],
})
export class TransactionsModule {}
