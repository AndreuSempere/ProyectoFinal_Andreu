import { IsInt, IsNumber, IsNotEmpty, IsOptional, IsEnum, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger'

export class CreateTransactionDto {
  @ApiProperty({ example: 612345678})
  @IsInt()
  @IsNotEmpty()
  accountId: number;

  @ApiProperty({ example: 666666666})
  @IsOptional()
  @IsInt()
  targetAccountId?: number;

  @ApiProperty({ example: 10})
  @IsNumber()
  @IsNotEmpty()
  cantidad: number;

  @ApiProperty({ example: 'gasto'})
  @IsEnum(['ingreso', 'gasto'])
  @IsNotEmpty()
  tipo: 'ingreso' | 'gasto';

  @ApiProperty({ example: "Prueba de Swagger"})
  @IsOptional()
  @IsString()
  descripcion?: string;
}
