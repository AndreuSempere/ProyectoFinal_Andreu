import {
  Body,
  Controller,
  Delete,
  Get,
  NotFoundException,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { AccountsService } from './accounts.service';
import { CreateAccountDto, UpdateAccountDto } from './accounts.dto';
import { ApiOperation, ApiResponse, ApiParam, ApiQuery } from '@nestjs/swagger';

@Controller('accounts')
export class AccountsController {
  private accountsService: AccountsService;

  constructor(accountsService: AccountsService) {
    this.accountsService = accountsService;
  }

  @Get()
  @ApiOperation({ summary: 'Get all accounts' })
  @ApiQuery({
    name: 'xml',
    required: false,
    type: String,
    description: 'Format the response in XML',
  })
  @ApiResponse({
    status: 200,
    description: 'Successfully retrieved all accounts',
  })
  @ApiResponse({ status: 500, description: 'Internal server error' })
  getAccountAll(@Query('xml') xml: string) {
    return this.accountsService.getAccountAll(xml);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get account by ID' })
  @ApiParam({ name: 'id', type: Number, description: 'Account ID' })
  @ApiQuery({
    name: 'xml',
    required: false,
    type: String,
    description: 'Format the response in XML',
  })
  @ApiResponse({ status: 200, description: 'Successfully retrieved account' })
  @ApiResponse({ status: 404, description: 'Account not found' })
  @ApiResponse({ status: 500, description: 'Internal server error' })
  async getAccount(@Param('id') id: string, @Query('xml') xml: string) {
    const accountId = parseInt(id);
    if (isNaN(accountId)) {
      throw new NotFoundException('Account not found');
    }
    const account = await this.accountsService.getAccount(accountId, xml);
    if (!account) {
      throw new NotFoundException('Account not found');
    }
    return account;
  }

  @Get('user/:id')
  @ApiOperation({ summary: 'Get accounts by user ID' })
  @ApiParam({ name: 'id', type: Number, description: 'User ID' })
  @ApiResponse({
    status: 200,
    description: 'Successfully retrieved accounts by user',
  })
  @ApiResponse({ status: 404, description: 'User not found' })
  getAccountByUserId(@Param('id') id: string) {
    return this.accountsService.getAccountsByUserId(parseInt(id));
  }

  @Post()
  @ApiOperation({ summary: 'Create a new account' })
  @ApiResponse({ status: 201, description: 'Successfully created account' })
  @ApiResponse({ status: 400, description: 'Failed to create account' })
  createAccount(@Body() createAccoutDto: CreateAccountDto) {
    return this.accountsService.createAccount(createAccoutDto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update account by ID' })
  @ApiParam({ name: 'id', type: Number, description: 'Account ID to update' })
  @ApiResponse({ status: 200, description: 'Successfully updated account' })
  @ApiResponse({ status: 404, description: 'Account not found' })
  @ApiResponse({ status: 400, description: 'Failed to update account' })
  updateAccount(
    @Param('id') id: string,
    @Body() updateAccountDto: UpdateAccountDto,
  ) {
    return this.accountsService.updateAccount(parseInt(id), updateAccountDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete account by ID' })
  @ApiParam({ name: 'id', type: Number, description: 'Account ID to delete' })
  @ApiResponse({ status: 200, description: 'Successfully deleted account' })
  @ApiResponse({ status: 404, description: 'Account not found' })
  @ApiResponse({ status: 400, description: 'Failed to delete account' })
  deleteAccount(@Param('id') id: string) {
    return this.accountsService.deleteAccount(parseInt(id));
  }
}
