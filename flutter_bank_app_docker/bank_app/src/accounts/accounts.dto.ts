// user.dto.ts
import {
  IsEmail,
  IsString,
  IsOptional,
  IsInt,
  Min,
  Max,
  Length,
} from 'class-validator';
export class CreateAccoutDto {
  @IsOptional()
  @IsInt()
  numero_cuenta?: number;

  @IsInt()
  saldo: number;

  @IsString()
  moneda: string;

  @IsString()
  estado: string;

  @IsString()
  @Length(1, 9)
  fecha_creacion: string;

  @IsInt()
  accounts_type: number;

  @IsInt()
  id_user: number;
}

export class UpdateAccountDto {

  @IsOptional()
  @IsInt()
  numero_cuenta?: number;

  @IsOptional()
  @IsInt()
  saldo: number;

  @IsOptional()
  @IsString()
  moneda: string;

  @IsOptional()
  @IsString()
  estado: string;

  @IsOptional()
  @IsString()
  @Length(1, 9)
  fecha_creacion: string;

  @IsOptional()
  @IsInt()
  accounts_type: number;

  @IsOptional()
  @IsInt()
  id_user: number;
}