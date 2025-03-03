import { IsNotEmpty, IsNumber, IsPositive } from 'class-validator';

export class CreateInvestmentDto {
  @IsNotEmpty()
  @IsNumber()
  account_id: number;

  @IsNotEmpty()
  @IsNumber()
  trading_id: number;

  @IsNotEmpty()
  @IsNumber()
  @IsPositive()
  amount: number;
}

export class InvestmentResponseDto {
  id: number;

  account_id: number;

  trading_id: number;

  symbol: string;

  name: string;

  amount: number;

  purchase_price: number;

  current_value: number;

  profit_loss_percentage: number;

  purchase_date: Date;

  last_updated: Date;
}
