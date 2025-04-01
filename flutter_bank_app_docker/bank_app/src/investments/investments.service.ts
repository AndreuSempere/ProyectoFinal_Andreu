import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Investment } from './investments.entity';
import { CreateInvestmentDto, InvestmentResponseDto } from './investments.dto';
import { Accounts } from '../accounts/accounts.entity';
import { TradingEntity } from '../trading/trading.entity';

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

  // Sacar todas las inversiones asociadas a unn id_cuenta
  async getAllInvestments(
    accountId?: number,
  ): Promise<InvestmentResponseDto[]> {
    try {
      let query = this.investmentsRepository
        .createQueryBuilder('investment')
        .leftJoinAndSelect('investment.account', 'account')
        .leftJoinAndSelect('investment.trading', 'trading');

      if (accountId) {
        query = query.where('account.id_cuenta = :accountId', { accountId });
      }

      const investments = await query.getMany();
      return investments.map((investment) => this.mapToResponseDto(investment));
    } catch (error) {
      throw new HttpException(
        `Error al obtener inversiones: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  // Obtener una inversión por su id
  async getInvestmentById(
    idInvestment: number,
  ): Promise<InvestmentResponseDto> {
    try {
      const investment = await this.investmentsRepository.findOne({
        where: { idInvestment },
        relations: ['account', 'trading'],
      });

      if (!investment) {
        throw new HttpException(
          'Inversión no encontrada',
          HttpStatus.NOT_FOUND,
        );
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

  // Crear una nueva inversión
  async createInvestment(
    createInvestmentDto: CreateInvestmentDto,
  ): Promise<InvestmentResponseDto> {
    try {
      const account = await this.accountsRepository.findOne({
        where: { id_cuenta: createInvestmentDto.account_id },
        relations: ['accounts_type'],
      });

      if (!account) {
        throw new HttpException('Cuenta no encontrada', HttpStatus.NOT_FOUND);
      }

      // Verificar si la cuenta es de tipo inversiones
      if (account.accounts_type.id_type !== 3) {
        throw new HttpException(
          'Solo las cuentas de tipo Inversiones pueden tener inversiones',
          HttpStatus.BAD_REQUEST,
        );
      }

      // Obtener la información del trading por el símbolo
      const trading = await this.tradingRepository.findOne({
        where: { symbol: createInvestmentDto.symbol },
      });

      if (!trading) {
        throw new HttpException(
          'Activo de trading no encontrado',
          HttpStatus.NOT_FOUND,
        );
      }

      // Obtener el regisdtro más reciente de trading por el símbolo
      const latestTradingData = await this.tradingRepository.findOne({
        where: { symbol: trading.symbol },
        order: { recordedAt: 'DESC' },
      });

      if (!latestTradingData) {
        throw new HttpException(
          'No se encontraron datos de precio para el activo',
          HttpStatus.BAD_REQUEST,
        );
      }

      // Obtener el precio actual del trading
      const currentPrice = latestTradingData.price;

      if (account.saldo < createInvestmentDto.amount) {
        throw new HttpException(
          'Saldo insuficiente para realizar la inversión',
          HttpStatus.BAD_REQUEST,
        );
      }

      // Actualizar el saldo de la cuenta
      account.saldo -= createInvestmentDto.amount;
      await this.accountsRepository.save(account);

      const investment = this.investmentsRepository.create({
        account,
        trading,
        amount: createInvestmentDto.amount,
        purchase_price: currentPrice,
        current_value: currentPrice,
        purchase_date: new Date(),
        last_updated: new Date(),
        name_trading: trading.name
      });

      const savedInvestment = await this.investmentsRepository.save(investment);

      const updatedInvestment = await this.investmentsRepository.findOne({
        where: { idInvestment: savedInvestment.idInvestment },
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

  // Calcular el porcentaje de ganancia/pérdida de la inversión
  private mapToResponseDto(investment: Investment): InvestmentResponseDto {
    const totalInvested = investment.amount * investment.purchase_price;
    const currentValue = investment.amount * investment.current_value;
    const profitLossPercentage =
      ((currentValue - totalInvested) / totalInvested) * 100;

    return {
      id: investment.idInvestment,
      account_id: investment.account.id_cuenta,
      symbol: investment.trading.symbol,
      name: investment.trading.name,
      amount: investment.amount,
      purchase_price: investment.purchase_price,
      current_value: investment.current_value,
      profit_loss_percentage: Number(profitLossPercentage.toFixed(2)),
      purchase_date: investment.purchase_date,
      last_updated: investment.last_updated,
      name_trading: investment.name_trading
    };
  }
}
