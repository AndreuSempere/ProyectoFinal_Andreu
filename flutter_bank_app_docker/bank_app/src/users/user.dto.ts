// user.dto.ts
import {
  IsEmail,
  IsString,
  IsOptional,
  IsInt,
  Length,
  IsPhoneNumber,
  IsNumberString,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ example: 1, description: 'ID del usuario, opcional al crear un nuevo usuario.' })
  @IsOptional()
  @IsInt()
  id_user?: number;

  @ApiProperty({ example: 'Juan', description: 'Nombre del usuario.' })
  @IsString()
  @Length(1, 500)
  name: string;

  @ApiProperty({ example: 'Pérez', description: 'Apellido del usuario.' })
  @IsString()
  @Length(1, 500)
  surname: string;

  @ApiProperty({ example: 'password123', description: 'Contraseña del usuario.' })
  @IsString()
  password: string;

  @ApiProperty({ example: 'juan.perez@example.com', description: 'Correo electrónico del usuario.' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 123456789, description: 'Número de teléfono del usuario (opcional).' })
  @IsInt()
  @IsOptional()
  telf?: number;

  @ApiProperty({ example: '12345678Z', description: 'DNI del usuario (opcional).' })
  @IsString()
  @Length(1, 9)
  dni: string | null;

  @ApiProperty({ example: '17/07/2001', description: 'Edad del usuario.' })
  @IsNumberString()
  @IsOptional()
  edad?: string;
}

export class UpdateUserDto {
  @ApiProperty({ example: 1, description: 'ID del usuario, opcional al actualizar los datos de un usuario.' })
  @IsOptional()
  @IsInt()
  id_user?: number;

  @ApiProperty({ example: 'Carlos', description: 'Nombre del usuario (opcional).' })
  @IsString()
  @IsOptional()
  @Length(1, 50)
  name?: string;

  @ApiProperty({ example: 'Lopez', description: 'Apellido del usuario (opcional).' })
  @IsString()
  @IsOptional()
  @Length(1, 50)
  surname?: string;

  @ApiProperty({ example: 'newpassword456', description: 'Contraseña del usuario (opcional).' })
  @IsString()
  @IsOptional()
  password?: string;

  @ApiProperty({ example: 'carlos.lopez@example.com', description: 'Correo electrónico del usuario (opcional).' })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiProperty({ example: 987654321, description: 'Número de teléfono del usuario (opcional).' })
  @IsInt()
  @IsOptional()
  telf?: number;

  @ApiProperty({ example: '87654321Y', description: 'DNI del usuario (opcional).' })
  @IsString()
  @IsOptional()
  dni?: string;

  @ApiProperty({ example: '17/07/2001', description: 'Edad del usuario (opcional, debe ser un número).' })
  @IsNumberString()
  @IsOptional()
  edad?: string;
}
