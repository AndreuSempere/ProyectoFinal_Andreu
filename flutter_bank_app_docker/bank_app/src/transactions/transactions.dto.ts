import { IsEnum, IsInt, IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';

export class CreateTransactionDto {

  @IsNumber()
  @IsNotEmpty()
  cantidad: number;

  @IsEnum(['ingreso', 'gasto'])
  @IsNotEmpty()
  tipo: 'ingreso' | 'gasto';

  @IsOptional()
  @IsString()
  descripcion?: string;

  @IsInt()
  accountId: number;
}
