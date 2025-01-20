import { IsInt, IsNumber, IsNotEmpty, IsOptional, IsEnum, IsString } from 'class-validator';

export class CreateTransactionDto {
  @IsInt()
  @IsNotEmpty()
  accountId: number;

  @IsOptional()
  @IsInt()
  targetAccountId?: number;

  @IsNumber()
  @IsNotEmpty()
  cantidad: number;

  @IsEnum(['ingreso', 'gasto'])
  @IsNotEmpty()
  tipo: 'ingreso' | 'gasto';

  @IsOptional()
  @IsString()
  descripcion?: string;
}
