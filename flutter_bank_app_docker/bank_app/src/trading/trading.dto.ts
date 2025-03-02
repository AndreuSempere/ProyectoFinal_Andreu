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

export class UpdateTradingDto {
    @ApiProperty({
      example: 1,
      description: 'ID del registro de trading',
    })
    @IsOptional()
    @IsInt()
    id?: number;
  
    @ApiProperty({
      example: 'Criptomoneda',
      description: 'Nuevo tipo de activo',
      required: false,
    })
    @IsOptional()
    @IsString()
    @Length(3, 20)
    type?: string;
  
    @ApiProperty({
      example: 'Ethereum',
      description: 'Nuevo nombre del activo',
      required: false,
    })
    @IsOptional()
    @IsString()
    @Length(2, 50)
    name?: string;
  
    @ApiProperty({
      example: 'ETH',
      description: 'Nuevo símbolo del activo',
      required: false,
    })
    @IsOptional()
    @IsString()
    @Length(1, 10)
    symbol?: string;
  
    @ApiProperty({
      example: 3000.75,
      description: 'Nuevo precio del activo',
      required: false,
      type: Number,
    })
    @IsOptional()
    @IsNumber()
    @Min(0)
    price?: number;
  }