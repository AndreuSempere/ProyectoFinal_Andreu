import { IsEnum, IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';

export class CreateTransactionDto {
  @IsNumber()
  @IsNotEmpty()
  accountId: number;

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
