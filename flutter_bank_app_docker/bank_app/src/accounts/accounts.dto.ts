import { IsString, IsOptional, IsInt, Min, Max, Length } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateAccoutDto {
  @ApiProperty({
    example: 123456789,
    description: 'Account number (16 digits)',
  })
  @IsInt()
  @Min(1000000000000000)
  @Max(9999999999999999)
  numero_cuenta: number;

  @ApiProperty({
    example: 1000,
    description: 'Account balance',
  })
  @IsInt()
  saldo: number;

  @ApiProperty({
    example: 'active',
    description: 'Account status (e.g., active, inactive)',
  })
  @IsString()
  estado: string;

  @ApiProperty({
    example: '2025-02-09',
    description: 'Account creation date (format: YYYY-MM-DD)',
  })
  @IsString()
  @Length(1, 9)
  fecha_creacion: string;

  @ApiProperty({
    example: 'Main checking account',
    description: 'Description of the account',
  })
  @IsString()
  description: string;

  @ApiProperty({
    example: 'bank-icon.png',
    description: 'Icon associated with the account',
  })
  @IsString()
  icon: string;

  @ApiProperty({
    example: 1,
    description: 'Account type ID',
  })
  @IsInt()
  accounts_type: number;

  @ApiProperty({
    example: 1,
    description: 'User ID associated with the account',
  })
  @IsInt()
  id_user: number;
}

export class UpdateAccountDto {
  @ApiProperty({
    example: 123456789,
    description: 'Account number (optional, max 16 digits)',
    required: false,
  })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(9999999999999999)
  numero_cuenta?: number;

  @ApiProperty({
    example: 1500,
    description: 'Account balance (optional)',
    required: false,
  })
  @IsOptional()
  @IsInt()
  saldo?: number;

  @ApiProperty({
    example: 'active',
    description: 'Account status (optional)',
    required: false,
  })
  @IsOptional()
  @IsString()
  estado?: string;

  @ApiProperty({
    example: '2025-02-09',
    description: 'Account creation date (optional, format: YYYY-MM-DD)',
    required: false,
  })
  @IsOptional()
  @IsString()
  @Length(1, 9)
  fecha_creacion?: string;

  @ApiProperty({
    example: 'Updated description',
    description: 'Description of the account (optional)',
    required: false,
  })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({
    example: 'updated-icon.png',
    description: 'Icon associated with the account (optional)',
    required: false,
  })
  @IsOptional()
  @IsString()
  icon?: string;

  @ApiProperty({
    example: 2,
    description: 'Account type ID (optional)',
    required: false,
  })
  @IsOptional()
  @IsInt()
  accounts_type?: number;

  @ApiProperty({
    example: 1,
    description: 'User ID associated with the account (optional)',
    required: false,
  })
  @IsOptional()
  @IsInt()
  id_user?: number;
}
