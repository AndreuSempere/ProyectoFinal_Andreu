import { forwardRef, Module } from '@nestjs/common';
import { Credit_CardService } from './credit_card.service';
import { UtilsModule } from '../utils/utils.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Credit_CardController } from './credit_card.controller';
import { Credit_Card } from './credit_card.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Credit_Card]),
    UtilsModule,
  ],
  exports: [TypeOrmModule, Credit_CardService],
  controllers: [Credit_CardController],
  providers: [Credit_CardService],
})
export class Credit_CardModule {}
