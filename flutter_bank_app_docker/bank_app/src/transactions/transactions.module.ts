import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TransactionsService } from './transactions.service';
import { TransactionsController } from './transactions.controller';
import { Transaction } from './transactions.entity';
import { Accounts } from '../accounts/accounts.entity';
import { AccountsModule } from '../accounts/accounts.module';
import { FirebaseModule } from 'src/firebase/firebase.module';
import { HttpModule } from '@nestjs/axios';

@Module({
  imports: [
    TypeOrmModule.forFeature([Transaction, Accounts]),
    AccountsModule,
    FirebaseModule,
    HttpModule,
  ],
  controllers: [TransactionsController],
  providers: [TransactionsService],
})
export class TransactionsModule {}
