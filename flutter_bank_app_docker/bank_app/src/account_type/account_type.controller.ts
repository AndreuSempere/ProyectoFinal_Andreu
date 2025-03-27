import {
  Body,
  Controller,
  Delete,
  Get,
  HttpException,
  HttpStatus,
  Param,
  Post,
  Put,
  Query,
  Res,
} from '@nestjs/common';
import { Response } from 'express';
import { AccountTypeService } from './account_type.service';
import { ApiOperation, ApiResponse, ApiParam } from '@nestjs/swagger';
import {
  CreateAccounts_typeDto,
  UpdateAccounts_typeDto,
} from './account_type.dto';

@Controller('account_type')
export class AccountTypeController {
  constructor(private readonly accountTypeService: AccountTypeService) {}

  @Get()
  @ApiOperation({ summary: 'Get all account types' })
  @ApiResponse({
    status: 200,
    description: 'Successfully retrieved all account types.',
  })
  @ApiResponse({ status: 500, description: 'Internal server error' })
  async getAllAccountType(
    @Query('format') format?: string,
    @Res() res?: Response,
  ) {
    const data = await this.accountTypeService.getAllAccountType(format);

    if (format === 'xml' && res) {
      res.set('Content-Type', 'application/xml');
      return res.send(data);
    }

    return res ? res.json(data) : data;
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get account type by ID' })
  @ApiParam({ name: 'id', type: Number, description: 'Account type ID' })
  @ApiResponse({
    status: 200,
    description: 'Successfully retrieved account type.',
  })
  @ApiResponse({ status: 404, description: 'Account type not found' })
  @ApiResponse({ status: 500, description: 'Internal server error' })
  async getAccountType(
    @Param('id') id: string,
    @Query('format') format?: string,
    @Res() res?: Response,
  ) {
    const data = await this.accountTypeService.getAccountType(
      parseInt(id),
      format,
    );

    if (format === 'xml' && res) {
      res.set('Content-Type', 'application/xml');
      return res.send(data);
    }

    return res ? res.json(data) : data;
  }

  @Post()
  @ApiOperation({ summary: 'Create a new account type' })
  @ApiResponse({
    status: 201,
    description: 'Successfully created account type.',
  })
  @ApiResponse({ status: 400, description: 'Failed to create account type' })
  createAccountType(@Body() createAccoutTypeDto: CreateAccounts_typeDto) {
    return this.accountTypeService.createAccountType(createAccoutTypeDto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update account type by ID' })
  @ApiParam({
    name: 'id',
    type: Number,
    description: 'Account type ID to update',
  })
  @ApiResponse({
    status: 200,
    description: 'Successfully updated account type.',
  })
  @ApiResponse({ status: 404, description: 'Account type not found' })
  @ApiResponse({ status: 400, description: 'Failed to update account type' })
  async updateAccountType(
    @Param('id') id: string,
    @Body() updateAccountTypeDto: UpdateAccounts_typeDto,
  ) {
    try {
      return await this.accountTypeService.updateAccountType({
        ...updateAccountTypeDto,
        id_type: parseInt(id),
      });
    } catch (err) {
      throw new HttpException(
        {
          status: HttpStatus.NOT_FOUND,
          error: err.message || 'Account Type not found',
        },
        HttpStatus.NOT_FOUND,
      );
    }
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete account type by ID' })
  @ApiParam({
    name: 'id',
    type: Number,
    description: 'Account type ID to delete',
  })
  @ApiResponse({
    status: 200,
    description: 'Successfully deleted account type.',
  })
  @ApiResponse({ status: 404, description: 'Account type not found' })
  @ApiResponse({ status: 400, description: 'Failed to delete account type' })
  deleteAccountType(@Param('id') id: string) {
    return this.accountTypeService.deleteAccountType(parseInt(id));
  }
}
