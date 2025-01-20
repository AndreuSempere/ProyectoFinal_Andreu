import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
  Res,
} from '@nestjs/common';
import { AccountsService } from './accounts.service';
import { CreateAccoutDto, UpdateAccountDto } from './accounts.dto';

@Controller('accounts')
export class AccountsController {
  private accountsService: AccountsService;
  constructor(accountsService: AccountsService) {
    this.accountsService = accountsService;
  }

  @Get()
  getAccountAll(@Query('xml') xml: string) {
    return this.accountsService.getAccountAll(xml);
  }

  @Get(':id')
  getAccount(@Param('id') id: string, @Query('xml') xml: string) {
    return this.accountsService.getAccount(parseInt(id), xml);
  }

  @Get('user/:id')
  getAccountByUserId(@Param('id') id: string) {
    return this.accountsService.getAccountsByUserId(parseInt(id));
  }

  @Post()
  createAccount(@Body() createAccoutDto: CreateAccoutDto) {
    return this.accountsService.createAccount(createAccoutDto);
  }

  @Put(':id')
  updateAccount(
    @Param('id') id: string,
    @Body() updateAccountDto: UpdateAccountDto,
  ) {
    return this.accountsService.updateAccount(
      parseInt(id),
      updateAccountDto,
    );
  }

  @Delete(':id')
  deleteAccount(@Param('id') id: string) {
    return this.accountsService.deleteAccount(parseInt(id));
  }
}
