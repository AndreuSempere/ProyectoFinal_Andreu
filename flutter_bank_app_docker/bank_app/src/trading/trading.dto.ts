import { IsString, IsNumber, Min, Length, IsOptional, IsInt } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateTradingDto {
  @ApiProperty({
    example: 'Acción',
    description: 'Tipo de activo (Acción, Criptomoneda, Materia Prima)',
  })
  @IsString()
  @Length(3, 20)
  type: string;

  @ApiProperty({
    example: 'Tesla',
    description: 'Nombre del activo',
  })
  @IsString()
  @Length(2, 50)
  name: string;

  @ApiProperty({
    example: 'TSLA',
    description: 'Símbolo del activo',
  })
  @IsString()
  @Length(1, 10)
  symbol: string;

  @ApiProperty({
    example: 200.50,
    description: 'Precio actual del activo',
    type: Number,
  })
  @IsNumber()
  @Min(0)
  price: number;
}