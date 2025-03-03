import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Investment } from './investments.entity';
import { CreateInvestmentDto, InvestmentResponseDto } from './investments.dto';
import { Accounts } from '../accounts/accounts.entity';
import { TradingEntity } from '../trading/trading.entity';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class InvestmentsService {
  constructor(
    @InjectRepository(Investment)
    private investmentsRepository: Repository<Investment>,
    @InjectRepository(Accounts)
    private accountsRepository: Repository<Accounts>,
    @InjectRepository(TradingEntity)
    private tradingRepository: Repository<TradingEntity>,
  ) {}

  async getAllInvestments(accountId?: number): Promise<InvestmentResponseDto[]> {
    try {
      let query = this.investmentsRepository
        .createQueryBuilder('investment')
        .leftJoinAndSelect('investment.account', 'account')
        .leftJoinAndSelect('investment.trading', 'trading');

      if (accountId) {
        query = query.where('account.id_cuenta = :accountId', { accountId });
      }

      const investments = await query.getMany();

      // Transformar los resultados al DTO de respuesta
      return investments.map(investment => this.mapToResponseDto(investment));
    } catch (error) {
      throw new HttpException(
        `Error al obtener inversiones: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async getInvestmentById(id: number): Promise<InvestmentResponseDto> {
    try {
      const investment = await this.investmentsRepository.findOne({
        where: { id },
        relations: ['account', 'trading'],
      });

      if (!investment) {
        throw new HttpException('Inversión no encontrada', HttpStatus.NOT_FOUND);
      }

      return this.mapToResponseDto(investment);
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      throw new HttpException(
        `Error al obtener inversión: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async createInvestment(createInvestmentDto: CreateInvestmentDto): Promise<InvestmentResponseDto> {
    try {
      const account = await this.accountsRepository.findOne({
        where: { id_cuenta: createInvestmentDto.account_id },
        relations: ['accounts_type'],
      });

      if (!account) {
        throw new HttpException('Cuenta no encontrada', HttpStatus.NOT_FOUND);
      }

      if (account.accounts_type.id_type !== 3) {
        throw new HttpException(
          'Solo las cuentas de tipo Inversiones pueden tener inversiones',
          HttpStatus.BAD_REQUEST,
        );
      }

      const trading = await this.tradingRepository.findOne({
        where: { id: createInvestmentDto.trading_id },
      });

      if (!trading) {
        throw new HttpException('Activo de trading no encontrado', HttpStatus.NOT_FOUND);
      }

      // Obtener el precio actual
      const latestTradingData = await this.tradingRepository.findOne({
        where: { symbol: trading.symbol },
        order: { recordedAt: 'DESC' }
      });

      if (!latestTradingData) {
        throw new HttpException(
          'No se encontraron datos de precio para el activo',
          HttpStatus.BAD_REQUEST,
        );
      }

      // Usar el precio actual de la base de datos
      const currentPrice = latestTradingData.price;
      
      // Verificar que la cuenta tiene saldo suficiente
      const investmentAmount = createInvestmentDto.amount * currentPrice;
      if (account.saldo < investmentAmount) {
        throw new HttpException(
          'Saldo insuficiente para realizar la inversión',
          HttpStatus.BAD_REQUEST,
        );
      }

      // Actualizar el saldo de la cuenta
      account.saldo -= investmentAmount;
      await this.accountsRepository.save(account);

      // Crear la inversión
      const investment = this.investmentsRepository.create({
        account,
        trading,
        amount: createInvestmentDto.amount,
        purchase_price: currentPrice,
        current_value: currentPrice,
        purchase_date: new Date(),
        last_updated: new Date(),
      });

      const savedInvestment = await this.investmentsRepository.save(investment);

      // Obtener la inversión actualizada
      const updatedInvestment = await this.investmentsRepository.findOne({
        where: { id: savedInvestment.id },
        relations: ['account', 'trading'],
      });

      return this.mapToResponseDto(updatedInvestment);
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      throw new HttpException(
        `Error al crear inversión: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  private mapToResponseDto(investment: Investment): InvestmentResponseDto {
    const totalInvested = investment.amount * investment.purchase_price;
    const currentValue = investment.amount * investment.current_value;
    const profitLossPercentage = ((currentValue - totalInvested) / totalInvested) * 100;

    return {
      id: investment.id,
      account_id: investment.account.id_cuenta,
      trading_id: investment.trading.id,
      symbol: investment.trading.symbol,
      name: investment.trading.name,
      amount: investment.amount,
      purchase_price: investment.purchase_price,
      current_value: investment.current_value,
      profit_loss_percentage: Number(profitLossPercentage.toFixed(2)),
      purchase_date: investment.purchase_date,
      last_updated: investment.last_updated,
    };
  }
}
