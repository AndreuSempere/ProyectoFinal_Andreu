import {
  IsString,
  IsOptional,
  IsInt,
  IsDateString,
  Min,
  Max,
  IsNotEmpty,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateCreditCardDto {
  @ApiProperty({
    example: 1234567890123456,
    description: 'The credit card number',
  })
  @IsInt()
  @Min(1000000000000000)
  @Max(9999999999999999)
  numero_tarjeta: number;

  @ApiProperty({
    example: 'Visa',
    description: 'The type of the credit card (e.g., Visa, MasterCard)',
  })
  @IsString()
  tipo_tarjeta: string;

  @ApiProperty({
    example: 'John Doe',
    description: 'The name of the cardholder',
  })
  @IsString()
  cardHolderName: string;

  @ApiProperty({
    example: '2025-12-31',
    description: 'The expiration date of the credit card (ISO format)',
  })
  @IsDateString()
  fecha_expiracion: string;

  @ApiProperty({
    example: 123,
    description: 'The CVV/CVC code of the credit card',
  })
  @IsInt()
  @Min(100)
  @Max(999)
  cvv: number;

  @ApiProperty({
    example: 1,
    description: 'The color identifier for the card',
  })
  @IsInt()
  color: number;

  @ApiProperty({
    example: 12345,
    description: 'The account ID linked to the credit card',
  })
  @IsInt()
  @IsNotEmpty()
  id_cuenta: number;
}

export class UpdateCreditCardDto {
  @ApiProperty({
    example: 1234567890123456,
    description: 'The credit card number',
    required: false,
  })
  @IsOptional()
  @IsInt()
  @Min(1000000000000000)
  @Max(9999999999999999)
  numero_tarjeta?: number;

  @ApiProperty({
    example: 'Visa',
    description: 'The type of the credit card (e.g., Visa, MasterCard)',
    required: false,
  })
  @IsOptional()
  @IsString()
  tipo_tarjeta?: string;

  @ApiProperty({
    example: '2025-12-31',
    description: 'The expiration date of the credit card (ISO format)',
    required: false,
  })
  @IsOptional()
  @IsDateString()
  fecha_expiracion?: string;

  @ApiProperty({
    example: 123,
    description: 'The CVV/CVC code of the credit card',
    required: false,
  })
  @IsOptional()
  @IsInt()
  @Min(100)
  @Max(999)
  cvv?: number;

  @ApiProperty({
    example: 1,
    description: 'The color identifier for the card',
    required: false,
  })
  @IsOptional()
  @IsInt()
  color?: number;

  @ApiProperty({
    example: 12345,
    description: 'The account ID linked to the credit card',
    required: false,
  })
  @IsOptional()
  @IsInt()
  id_cuenta?: number;
}
