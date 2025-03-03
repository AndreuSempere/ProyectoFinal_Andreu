import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { InvestmentsController } from './investments.controller';
import { InvestmentsService } from './investments.service';
import { Investment } from './investments.entity';
import { Accounts } from '../accounts/accounts.entity';
import { TradingEntity } from '../trading/trading.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Investment, Accounts, TradingEntity]),
  ],
  controllers: [InvestmentsController],
  providers: [InvestmentsService],
  exports: [InvestmentsService],
})
export class InvestmentsModule {}
