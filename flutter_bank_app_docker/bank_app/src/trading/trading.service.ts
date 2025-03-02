import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UtilsService } from '../utils/utils.service';
import { TradingEntity } from './trading.entity';
import { CreateTradingDto, UpdateTradingDto } from './trading.dto';

@Injectable()
export class TradingService {
  constructor(
    @InjectRepository(TradingEntity)
    private readonly tradingRepository: Repository<TradingEntity>,
    private readonly utilsService: UtilsService,
  ) {}

  async getAllTradingRecords(format?: string): Promise<any> {
    const tradingRecords = await this.tradingRepository.find();

    if (format === 'xml') {
      const jsonForXml = JSON.stringify({ TradingRecords: tradingRecords });
      return this.utilsService.convertJSONtoXML(jsonForXml);
    }

    return tradingRecords;
  }

  async getTradingRecord(id: number, format?: string): Promise<any> {
    const tradingRecord = await this.tradingRepository.findOne({
      where: { id },
    });

    if (!tradingRecord) {
      throw new HttpException('Registro de trading no encontrado', HttpStatus.NOT_FOUND);
    }

    if (format === 'xml') {
      const jsonForXml = JSON.stringify({ TradingRecord: tradingRecord });
      return this.utilsService.convertJSONtoXML(jsonForXml);
    }

    return tradingRecord;
  }

  async createTradingRecord(createTradingDto: CreateTradingDto): Promise<{ message: string }> {
    const newTradingRecord = this.tradingRepository.create(createTradingDto);
    await this.tradingRepository.save(newTradingRecord);
    return { message: 'Registro de trading creado satisfactoriamente' };
  }

  async updateTradingRecord(updateTradingDto: UpdateTradingDto): Promise<TradingEntity> {
    const tradingRecord = await this.tradingRepository.findOne({
      where: { id: updateTradingDto.id },
    });

    if (!tradingRecord) {
      throw new HttpException('Registro de trading no encontrado', HttpStatus.NOT_FOUND);
    }

    await this.tradingRepository.update(tradingRecord.id, updateTradingDto);
    return this.tradingRepository.findOne({ where: { id: updateTradingDto.id } });
  }

  async deleteTradingRecord(id: number): Promise<{ message: string }> {
    const result = await this.tradingRepository.delete(id);

    if (result.affected === 0) {
      throw new HttpException('Registro de trading no encontrado', HttpStatus.NOT_FOUND);
    }

    return { message: 'Registro de trading eliminado satisfactoriamente' };
  }
}
