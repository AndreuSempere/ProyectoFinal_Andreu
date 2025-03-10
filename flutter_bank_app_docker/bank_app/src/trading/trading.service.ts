import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UtilsService } from '../utils/utils.service';
import { TradingEntity } from './trading.entity';
import { CreateTradingDto } from './trading.dto';

@Injectable()
export class TradingService {
  constructor(
    @InjectRepository(TradingEntity)
    private readonly tradingRepository: Repository<TradingEntity>,
    private readonly utilsService: UtilsService,
  ) {}

  async getAllLatestTradingRecords(): Promise<any> {
    const query = this.tradingRepository.createQueryBuilder('trading')
      .orderBy('trading.id', 'DESC')
      .limit(15);

    const tradingRecords = await query.getMany();
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

}
