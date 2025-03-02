import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UtilsModule } from '../utils/utils.module';
import { TradingEntity } from './trading.entity';
import { TradingController } from './trading.controller';
import { TradingService } from './trading.service';

@Module({
  imports: [UtilsModule, TypeOrmModule.forFeature([TradingEntity])],
  controllers: [TradingController],
  providers: [TradingService],
})
export class TradingModule {}
