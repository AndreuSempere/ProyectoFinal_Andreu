import {
    Body,
    Controller,
    Delete,
    Get,
    HttpException,
    HttpStatus,
    Param,
    Post,
    Query,
    Res,
  } from '@nestjs/common';
  import { Response } from 'express';
  import { ApiOperation, ApiResponse, ApiParam, ApiTags } from '@nestjs/swagger';
import { TradingService } from './trading.service';
import { CreateTradingDto } from './trading.dto';
  
  @ApiTags('trading')
  @Controller('trading')
  export class TradingController {
    constructor(private readonly tradingService: TradingService) {}
  
    @Get()
    @ApiOperation({ summary: 'Get all trading records' })
    @ApiResponse({ status: 200, description: 'Successfully retrieved all trading records.' })
    @ApiResponse({ status: 500, description: 'Internal server error' })
    async getAllTradingRecords(@Res() res?: Response) {
      const data = await this.tradingService.getAllLatestTradingRecords();
      return res ? res.json(data) : data;
    }

    @Get(':name')
    @ApiOperation({ summary: 'Get trading record by name' })
    @ApiResponse({ status: 200, description: 'Successfully retrieved trading record.' })
    @ApiResponse({ status: 404, description: 'Trading record not found' })
    @ApiResponse({ status: 500, description: 'Internal server error' })
    async getTradingRecord(@Param('name') name: string) {
      const worthtrading = await this.tradingService.getTradingRecordsByName(name);
      if (!worthtrading || worthtrading.length === 0) {
      throw new HttpException('Trading record not found', HttpStatus.NOT_FOUND);
      }
      return worthtrading;
    }
  
    @Post()
    @ApiOperation({ summary: 'Create a new trading record' })
    @ApiResponse({ status: 201, description: 'Successfully created trading record.' })
    @ApiResponse({ status: 400, description: 'Failed to create trading record' })
    async createTradingRecord(@Body() createTradingDto: CreateTradingDto) {
      return await this.tradingService.createTradingRecord(createTradingDto);
    }
  
  }
  