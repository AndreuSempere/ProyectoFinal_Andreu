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
  import { ApiOperation, ApiResponse, ApiParam, ApiTags } from '@nestjs/swagger';
import { TradingService } from './trading.service';
import { CreateTradingDto, UpdateTradingDto } from './trading.dto';
  
  @ApiTags('trading')
  @Controller('trading')
  export class TradingController {
    constructor(private readonly tradingService: TradingService) {}
  
    @Get()
    @ApiOperation({ summary: 'Get all trading records' })
    @ApiResponse({ status: 200, description: 'Successfully retrieved all trading records.' })
    @ApiResponse({ status: 500, description: 'Internal server error' })
    async getAllTradingRecords(@Query('format') format?: string, @Res() res?: Response) {
      const data = await this.tradingService.getAllTradingRecords(format);
  
      if (format === 'xml' && res) {
        res.set('Content-Type', 'application/xml');
        return res.send(data);
      }
  
      return res ? res.json(data) : data;
    }
  
    @Get(':id')
    @ApiOperation({ summary: 'Get trading record by ID' })
    @ApiParam({ name: 'id', type: Number, description: 'Trading record ID' })
    @ApiResponse({ status: 200, description: 'Successfully retrieved trading record.' })
    @ApiResponse({ status: 404, description: 'Trading record not found' })
    @ApiResponse({ status: 500, description: 'Internal server error' })
    async getTradingRecord(@Param('id') id: string, @Query('format') format?: string, @Res() res?: Response) {
      const data = await this.tradingService.getTradingRecord(parseInt(id), format);
  
      if (!data) {
        throw new HttpException('Trading record not found', HttpStatus.NOT_FOUND);
      }
  
      if (format === 'xml' && res) {
        res.set('Content-Type', 'application/xml');
        return res.send(data);
      }
  
      return res ? res.json(data) : data;
    }
  
    @Post()
    @ApiOperation({ summary: 'Create a new trading record' })
    @ApiResponse({ status: 201, description: 'Successfully created trading record.' })
    @ApiResponse({ status: 400, description: 'Failed to create trading record' })
    async createTradingRecord(@Body() createTradingDto: CreateTradingDto) {
      return await this.tradingService.createTradingRecord(createTradingDto);
    }
  
    @Put(':id')
    @ApiOperation({ summary: 'Update trading record by ID' })
    @ApiParam({ name: 'id', type: Number, description: 'Trading record ID to update' })
    @ApiResponse({ status: 200, description: 'Successfully updated trading record.' })
    @ApiResponse({ status: 404, description: 'Trading record not found' })
    @ApiResponse({ status: 400, description: 'Failed to update trading record' })
    async updateTradingRecord(@Param('id') id: string, @Body() updateTradingDto: UpdateTradingDto) {
      try {
        return await this.tradingService.updateTradingRecord({
          ...updateTradingDto,
          id: parseInt(id),
        });
      } catch (err) {
        throw new HttpException(
          {
            status: HttpStatus.NOT_FOUND,
            error: err.message || 'Trading record not found',
          },
          HttpStatus.NOT_FOUND,
        );
      }
    }
  
    @Delete(':id')
    @ApiOperation({ summary: 'Delete trading record by ID' })
    @ApiParam({ name: 'id', type: Number, description: 'Trading record ID to delete' })
    @ApiResponse({ status: 200, description: 'Successfully deleted trading record.' })
    @ApiResponse({ status: 404, description: 'Trading record not found' })
    async deleteTradingRecord(@Param('id') id: string) {
      const deleted = await this.tradingService.deleteTradingRecord(parseInt(id));
      if (!deleted) {
        throw new HttpException('Trading record not found', HttpStatus.NOT_FOUND);
      }
      return { message: 'Trading record deleted successfully' };
    }
  }
  