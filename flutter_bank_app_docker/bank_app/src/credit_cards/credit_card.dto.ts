import {
  IsString,
  IsOptional,
  IsInt,
  IsDateString,
  Length,
  Min,
  Max,
} from 'class-validator';

export class CreateCreditCardDto {
  @IsInt()
  @Min(1000000000000000) // 16 digits minimum
  @Max(9999999999999999) // 16 digits maximum
  numero_tarjeta: number;

  @IsString()
  tipo_tarjeta: string;

  @IsDateString()
  fecha_expiracion: string;

  @IsInt()
  @Min(100)
  @Max(999)
  cvv: number;

  @IsString()
  estado: string;

  @IsInt()
  id_cuenta: number;
}

export class UpdateCreditCardDto {
  @IsOptional()
  @IsInt()
  @Min(1000000000000000)
  @Max(9999999999999999)
  numero_tarjeta?: number;

  @IsOptional()
  @IsString()
  tipo_tarjeta?: string;

  @IsOptional()
  @IsDateString()
  fecha_expiracion?: string;

  @IsOptional()
  @IsInt()
  @Min(100)
  @Max(999)
  cvv?: number;

  @IsOptional()
  @IsString()
  estado?: string;

  @IsOptional()
  @IsInt()
  id_cuenta?: number;
}
