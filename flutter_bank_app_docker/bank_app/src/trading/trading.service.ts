import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TradingEntity } from './trading.entity';
import { CreateTradingDto } from './trading.dto';

@Injectable()
export class TradingService {
  constructor(
    @InjectRepository(TradingEntity)
    private readonly tradingRepository: Repository<TradingEntity>,
  ) {}

  //Coger los 15 últimos registros de trading
  async getAllLatestTradingRecords(): Promise<any> {
    const query = this.tradingRepository
      .createQueryBuilder('trading')
      .orderBy('trading.idtrading', 'DESC')
      .limit(15);

    const tradingRecords = await query.getMany();
    return tradingRecords;
  }

  // Coger los registros de trading por nombre
  async getTradingRecordsByName(name: string): Promise<any> {
    const query = this.tradingRepository
      .createQueryBuilder('trading')
      .where('trading.name LIKE :name', { name: `%${name}%` });

    const tradingRecords = await query.getMany();
    if (!tradingRecords.length) {
      throw new HttpException(
        'No se encontraron registros de trading con ese nombre',
        HttpStatus.NOT_FOUND,
      );
    }

    return tradingRecords;
  }

  // Crear un nuevos registros de trading
  async createTradingRecord(
    createTradingDto: CreateTradingDto,
  ): Promise<{ message: string }> {
    const newTradingRecord = this.tradingRepository.create(createTradingDto);
    await this.tradingRepository.save(newTradingRecord);
    return { message: 'Registro de trading creado satisfactoriamente' };
  }
}
