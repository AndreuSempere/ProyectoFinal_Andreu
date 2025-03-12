import { Body, Controller, Delete, Get, Param, Post, NotFoundException, BadRequestException } from '@nestjs/common';
import { TransactionsService } from './transactions.service';
import { CreateTransactionDto } from './transactions.dto';
import { ApiOperation, ApiResponse } from '@nestjs/swagger';

@Controller('transaction')
export class TransactionsController {
  private transactionsService: TransactionsService;

  constructor(transactionsService: TransactionsService) {
    this.transactionsService = transactionsService;
  }

  @Get()
  @ApiOperation({ summary: 'Retrieve all transactions', description: 'Fetches all transactions from the database.' })
  @ApiResponse({ status: 200, description: 'Successfully fetched all transactions.' })
  @ApiResponse({ status: 500, description: 'Internal server error.' })
  async getTransactionAll() {
    try {
      return await this.transactionsService.getTransactionAll();
    } catch (err) {
      throw new BadRequestException('Error fetching transactions');
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Retrieve a specific transaction', description: 'Fetches a transaction by its ID.' })
  @ApiResponse({ status: 200, description: 'Successfully fetched the transaction.' })
  @ApiResponse({ status: 404, description: 'Transaction not found.' })
  async getTransaction(@Param('id') id: string) {
    const transactionId = parseInt(id);
    if (isNaN(transactionId)) {
      throw new BadRequestException('Invalid transaction ID');
    }

    const transaction = await this.transactionsService.getTransaction(transactionId);
    if (!transaction) {
      throw new NotFoundException('Transaction not found');
    }
    return transaction;
  }

  @Get('user/:id')
  @ApiOperation({ summary: 'Retrieve transactions by user ID', description: 'Fetches all transactions associated with a user ID.' })
  @ApiResponse({ status: 200, description: 'Successfully fetched the user transactions.' })
  @ApiResponse({ status: 404, description: 'User not found or no transactions available.' })
  async getTransactionsByAccountId(@Param('id') id: string) {
    const userId = parseInt(id);
    if (isNaN(userId)) {
      throw new BadRequestException('Invalid user ID');
    }

    const transactions = await this.transactionsService.getTransactionsByAccountId(userId);
    if (!transactions || transactions.length === 0) {
      throw new NotFoundException('User not found or no transactions available');
    }
    return transactions;
  }

  @Post()
  @ApiOperation({ summary: 'Create a new transaction', description: 'Creates a new transaction based on the provided data.' })
  @ApiResponse({ status: 201, description: 'Successfully created the transaction.' })
  @ApiResponse({ status: 400, description: 'Bad request, invalid data.' })
  async createTransaction(@Body() createTransactionDto: CreateTransactionDto) {
    try {
      return await this.transactionsService.createTransaction(createTransactionDto);
    } catch (err) {
      throw new BadRequestException('Failed to create transaction');
    }
  }

  @Post('/bizum/')
  @ApiOperation({ summary: 'Create a Bizum transaction', description: 'Creates a Bizum transaction based on the provided data.' })
  @ApiResponse({ status: 201, description: 'Successfully created the Bizum transaction.' })
  @ApiResponse({ status: 400, description: 'Bad request, invalid data.' })
  async bizumTransaction(@Body() createTransactionDto: CreateTransactionDto) {
    try {
      return await this.transactionsService.bizumTransaction(createTransactionDto);
    } catch (err) {
      throw new BadRequestException('Failed to create Bizum transaction');
    }
  }

  @Post('/qr/')
  @ApiOperation({ summary: 'Create a QR transaction', description: 'Creates a QR transaction based on the provided data.' })
  @ApiResponse({ status: 201, description: 'Successfully created the QR transaction.' })
  @ApiResponse({ status: 400, description: 'Bad request, invalid data.' })
  async qrTransaction(@Body() createTransactionDto: CreateTransactionDto) {
    try {
      return await this.transactionsService.qrTransaction(createTransactionDto);
    } catch (err) {
      throw new BadRequestException('Failed to create QR transaction');
    }
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a transaction', description: 'Deletes a transaction by its ID.' })
  @ApiResponse({ status: 200, description: 'Successfully deleted the transaction.' })
  @ApiResponse({ status: 404, description: 'Transaction not found.' })
  async deleteTransaction(@Param('id') id: string) {
    const transactionId = parseInt(id);
    if (isNaN(transactionId)) {
      throw new BadRequestException('Invalid transaction ID');
    }

    const result = await this.transactionsService.deleteTransaction(transactionId);
    if (!result) {
      throw new NotFoundException('Transaction not found');
    }
    return { message: 'Transaction successfully deleted' };
  }
}
