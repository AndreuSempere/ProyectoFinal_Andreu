import { IsString, IsOptional, IsInt } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateAccounts_typeDto {
  @ApiProperty({
    example: 'Create Description',
  })
  @IsString()
  description: string;
}

export class UpdateAccounts_typeDto {
  @ApiProperty({ example: 1 })
  @IsOptional()
  @IsInt()
  id_type?: number;

  @ApiProperty({
    example: 'Updated description',
    description: 'Description of the account type (optional)',
    required: false,
  })
  @IsOptional()
  @IsString()
  description?: string;
}
