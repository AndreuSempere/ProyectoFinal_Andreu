import { Controller, Get, Post, Body, Param, Query } from '@nestjs/common';
import { InvestmentsService } from './investments.service';
import { CreateInvestmentDto, InvestmentResponseDto } from './investments.dto';

@Controller('investments')
export class InvestmentsController {
  constructor(private readonly investmentsService: InvestmentsService) {}

  @Get()
  async getAllInvestments(@Query('accountId') accountId?: number): Promise<InvestmentResponseDto[]> {
    return this.investmentsService.getAllInvestments(accountId);
  }

  @Get(':id')
  async getInvestmentById(@Param('id') id: number): Promise<InvestmentResponseDto> {
    return this.investmentsService.getInvestmentById(id);
  }

  @Post()
  async createInvestment(@Body() createInvestmentDto: CreateInvestmentDto): Promise<InvestmentResponseDto> {
    return this.investmentsService.createInvestment(createInvestmentDto);
  }
}
