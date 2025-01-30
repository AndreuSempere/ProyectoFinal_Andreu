import { Body, Controller, Delete, Get, Param, Post } from '@nestjs/common';
import { TransactionsService } from './transactions.service';
import { CreateTransactionDto } from './transactions.dto';

@Controller('transaction')
export class TransactionsController {
   private transactionsService: TransactionsService;
    constructor(transactionsService: TransactionsService) {
      this.transactionsService = transactionsService;
    }

    @Get()
    getTransactionAll() {
      return this.transactionsService.getTransactionAll();
    }
  
    @Get(':id')
    getTransaction(@Param('id') id: string) {
      return this.transactionsService.getTransaction(parseInt(id));
    }

    @Get('user/:id')
    getTransactionsByUserId(@Param('id') id: string) {
    return this.transactionsService.getTransactionsByUserId(parseInt(id));
    }

    @Post()
    createTransaction(@Body() createTransactionDto: CreateTransactionDto) {
      return this.transactionsService.createTransaction(createTransactionDto);
    }

    @Post('/bizum/')
    bizumTransaction(@Body() createTransactionDto: CreateTransactionDto) {
      return this.transactionsService.bizumTransaction(createTransactionDto);
    }

    @Delete(':id')
    deleteTransaction(@Param('id') id: string) {
        return this.transactionsService.deleteTransaction(parseInt(id));
    }
}