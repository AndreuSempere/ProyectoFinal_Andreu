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
import { Response } from 'express';
import { AccountTypeService } from './account_type.service';

@Controller('account_type')
export class AccountTypeController {
  constructor(private readonly accountTypeService: AccountTypeService) {}

  @Get()
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
  createAccountType(@Body() account_type) {
    return this.accountTypeService.createAccountType(account_type);
  }

  @Put(':id')
  updateAccountType(@Param('id') id: string, @Body() account_type) {
    return this.accountTypeService.updateAccountType(
      parseInt(id),
      account_type,
    );
  }

  @Delete(':id')
  deleteAccountType(@Param('id') id: string) {
    return this.accountTypeService.deleteAccountType(parseInt(id));
  }
}
