// user.dto.ts
import {
  IsEmail,
  IsString,
  IsOptional,
  IsInt,
  Length,
} from 'class-validator';
export class CreateUserDto {
  @IsOptional()
  @IsInt()
  id_user?: number;

  @IsString()
  @Length(1, 500)
  name: string;

  @IsString()
  @Length(1, 500)
  surname: string;

  @IsString()
  password: string;

  @IsEmail()
  email: string;

  @IsInt()
  @IsOptional()
  telf?: number | null;

  @IsString()
  @Length(1, 9)
  dni: string | null ;

  @IsString()
  edad: string;
}

export class UpdateUserDto {
  @IsOptional()
  @IsInt()
  id_user?: number;

  @IsString()
  @IsOptional()
  @Length(1, 50)
  name?: string;

  @IsString()
  @IsOptional()
  @Length(1, 50)
  surname?: string;

  @IsString()
  @IsOptional()
  password?: string;

  @IsEmail()
  @IsOptional()
  email?: string;

  @IsInt()
  @IsOptional()
  telf?: number;

  @IsString()
  @IsOptional()
  dni?: string;

  @IsString()
  @IsOptional()
  edad?: string;
}
