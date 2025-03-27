import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsInt,
  IsOptional,
  IsEmail,
  Length,
  IsNumberString,
  Matches,
} from 'class-validator';

export class CreateUserDto {
  @ApiProperty({
    example: 1,
    description: 'ID del usuario, opcional al crear un nuevo usuario.',
  })
  @IsOptional()
  @IsInt()
  id_user?: number;

  @ApiProperty({ example: 'Juan', description: 'Nombre del usuario.' })
  @IsString()
  @Length(1, 50)
  name: string;

  @ApiProperty({ example: 'Pérez', description: 'Apellido del usuario.' })
  @IsString()
  @Length(1, 50)
  surname: string;

  @ApiProperty({
    example: 'password123',
    description: 'Contraseña del usuario (mínimo 5 caracteres).',
  })
  @IsString()
  @Length(6)
  password: string;

  @ApiProperty({
    example: 'juan.perez@example.com',
    description: 'Correo electrónico del usuario.',
  })
  @IsEmail()
  email: string;

  @ApiProperty({
    example: '612345678',
    description:
      'Número de teléfono del usuario (opcional, debe ser un número español de 9 dígitos).',
  })
  @Matches(/^[6-9]\d{8}$/, {
    message:
      'El teléfono debe ser un número español válido de 9 dígitos, comenzando con 6, 7, 8 o 9.',
  })
  @IsOptional()
  telf?: string;

  @ApiProperty({
    example: '12345678Z',
    description:
      'DNI del usuario (opcional, debe tener exactamente 9 caracteres).',
  })
  @IsString()
  @Length(9, 9, { message: 'El DNI debe tener exactamente 9 caracteres.' })
  dni: string | null;

  @ApiProperty({ example: '17/07/2001', description: 'Edad del usuario.' })
  @IsNumberString()
  @IsOptional()
  fecha_nacimiento?: string;
}

export class UpdateUserDto {
  @ApiProperty({
    example: 1,
    description:
      'ID del usuario, opcional al actualizar los datos de un usuario.',
  })
  @IsOptional()
  @IsInt()
  id_user?: number;

  @ApiProperty({
    example: 'Carlos',
    description: 'Nombre del usuario (opcional).',
  })
  @IsString()
  @IsOptional()
  @Length(1, 50)
  name?: string;

  @ApiProperty({
    example: 'Lopez',
    description: 'Apellido del usuario (opcional).',
  })
  @IsString()
  @IsOptional()
  @Length(1, 50)
  surname?: string;

  @ApiProperty({
    example: 'newpassword456',
    description: 'Contraseña del usuario (opcional, mínimo 5 caracteres).',
  })
  @IsString()
  @IsOptional()
  @Length(6)
  password?: string;

  @ApiProperty({
    example: 'carlos.lopez@example.com',
    description: 'Correo electrónico del usuario (opcional).',
  })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiProperty({
    example: '612345678',
    description:
      'Número de teléfono del usuario (opcional, debe ser un número español de 9 dígitos).',
  })
  @Matches(/^[6-9]\d{8}$/, {
    message:
      'El teléfono debe ser un número español válido de 9 dígitos, comenzando con 6, 7, 8 o 9.',
  })
  @IsOptional()
  telf?: string;

  @ApiProperty({
    example: '87654321Y',
    description:
      'DNI del usuario (opcional, debe tener exactamente 9 caracteres).',
  })
  @IsString()
  @IsOptional()
  @Length(9, 9, { message: 'El DNI debe tener exactamente 9 caracteres.' })
  dni?: string;

  @ApiProperty({
    example: '17/07/2001',
    description: 'Edad del usuario (opcional, debe ser un número).',
  })
  @IsNumberString()
  @IsOptional()
  fecha_nacimiento?: string;
}
