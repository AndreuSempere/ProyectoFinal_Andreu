import { Body, Controller, Delete, Get, Param, Post } from '@nestjs/common';
import { TransactionsService } from './transactions.service';
import { CreateTransactionDto } from './transactions.dto';

@Controller('transactions')
export class TransactionsController {
  constructor(private readonly transactionsService: TransactionsService) {}

    @Get()
    getAccountAll() {
      return this.transactionsService.getTransactionAll();
    }
  
    @Get(':id')
    getAccount(@Param('id') id: string) {
      return this.transactionsService.getTransaction(parseInt(id));
    }
  

    @Post()
    createTransaction(@Body() createTransactionDto: CreateTransactionDto) {
      return this.transactionsService.createTransaction(createTransactionDto);
    }

    @Delete(':id')
    deleteTransaction(@Param('id') id: string) {
        return this.transactionsService.deleteTransaction(parseInt(id));
    }
}