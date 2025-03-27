import { Test, TestingModule } from '@nestjs/testing';
import { InvestmentsService } from './investments.service';
import { Investment } from './investments.entity';
import { Accounts } from '../accounts/accounts.entity';
import { TradingEntity } from '../trading/trading.entity';
import { getRepositoryToken } from '@nestjs/typeorm';
import { HttpException } from '@nestjs/common';
import { CreateInvestmentDto } from './investments.dto';

const mockAccount = {
  id_cuenta: 1,
  numero_cuenta: 1234567890123456,
  saldo: 5000,
  estado: 'active',
  accounts_type: {
    id_type: 3,
    name: 'Inversiones',
  },
};

const mockTradingEntity = {
  id: 1,
  symbol: 'AAPL',
  name: 'Apple Inc.',
  price: 150.25,
  change: 2.5,
  change_percent: 1.69,
  market_cap: 2500000000000,
  recordedAt: new Date('2023-01-15'),
};

const investmentsArray = [
  {
    idInvestment: 1,
    account: mockAccount,
    trading: mockTradingEntity,
    amount: 10,
    purchase_price: 145.5,
    current_value: 150.25,
    purchase_date: new Date('2023-01-10'),
    last_updated: new Date('2023-01-15'),
  },
  {
    idInvestment: 2,
    account: mockAccount,
    trading: {
      ...mockTradingEntity,
      id: 2,
      symbol: 'MSFT',
      name: 'Microsoft Corporation',
      price: 320.75,
    },
    amount: 5,
    purchase_price: 310.25,
    current_value: 320.75,
    purchase_date: new Date('2023-01-12'),
    last_updated: new Date('2023-01-15'),
  },
];

const oneInvestment = investmentsArray[0];

const mockInvestmentResponseDto = {
  id: 1,
  account_id: 1,
  symbol: 'AAPL',
  name: 'Apple Inc.',
  amount: 10,
  purchase_price: 145.5,
  current_value: 150.25,
  profit_loss_percentage: 3.26,
  purchase_date: new Date('2023-01-10'),
  last_updated: new Date('2023-01-15'),
};

const createInvestmentDto: CreateInvestmentDto = {
  account_id: 1,
  symbol: 'AAPL',
  amount: 2000,
};

describe('InvestmentsService', () => {
  let investmentsService: InvestmentsService;

  const mockQueryBuilder = {
    leftJoinAndSelect: jest.fn().mockReturnThis(),
    where: jest.fn().mockReturnThis(),
    getMany: jest.fn().mockResolvedValue(investmentsArray),
  };

  const MockInvestmentsRepository = {
    findOne: jest.fn(({ where }) => {
      if (where?.idInvestment === 1) {
        return Promise.resolve(oneInvestment);
      }
      return Promise.resolve(null);
    }),
    create: jest.fn(() => ({
      idInvestment: 3,
      account: mockAccount,
      trading: mockTradingEntity,
      amount: createInvestmentDto.amount,
      purchase_price: mockTradingEntity.price,
      current_value: mockTradingEntity.price,
      purchase_date: new Date(),
      last_updated: new Date(),
    })),
    save: jest.fn((entity) => Promise.resolve(entity)),
    createQueryBuilder: jest.fn().mockReturnValue(mockQueryBuilder),
  };

  const MockAccountsRepository = {
    findOne: jest.fn(({ where }) => {
      if (where?.id_cuenta === 1) {
        return Promise.resolve(mockAccount);
      } else if (where?.id_cuenta === 999) {
        return Promise.resolve(null);
      } else if (where?.id_cuenta === 2) {
        return Promise.resolve({
          ...mockAccount,
          id_cuenta: 2,
          accounts_type: {
            id_type: 1,
            name: 'Corriente',
          },
        });
      } else if (where?.id_cuenta === 3) {
        return Promise.resolve({
          ...mockAccount,
          id_cuenta: 3,
          saldo: 100,
        });
      }
      return Promise.resolve(null);
    }),
    save: jest.fn((entity) => entity),
  };

  const MockTradingRepository = {
    findOne: jest.fn(({ where }) => {
      if (where?.symbol === 'AAPL') {
        return Promise.resolve(mockTradingEntity);
      } else if (where?.symbol === 'INVALID') {
        return Promise.resolve(null);
      }
      return Promise.resolve(null);
    }),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        InvestmentsService,
        {
          provide: getRepositoryToken(Investment),
          useValue: MockInvestmentsRepository,
        },
        {
          provide: getRepositoryToken(Accounts),
          useValue: MockAccountsRepository,
        },
        {
          provide: getRepositoryToken(TradingEntity),
          useValue: MockTradingRepository,
        },
      ],
    }).compile();

    investmentsService = module.get<InvestmentsService>(InvestmentsService);

    // Mock the private mapToResponseDto method
    jest
      .spyOn(investmentsService as any, 'mapToResponseDto')
      .mockImplementation((investment: Investment) => {
        if (!investment) {
          return null;
        }
        if (investment.idInvestment === 1) {
          return mockInvestmentResponseDto;
        }
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
        };
      });
  });

  it('should be defined', () => {
    expect(investmentsService).toBeDefined();
  });

  describe('getAllInvestments', () => {
    it('should return all investments', async () => {
      const result = await investmentsService.getAllInvestments();

      expect(MockInvestmentsRepository.createQueryBuilder).toHaveBeenCalledWith(
        'investment',
      );
      expect(mockQueryBuilder.leftJoinAndSelect).toHaveBeenCalledTimes(2);
      expect(result).toHaveLength(2);
      expect(result[0]).toEqual(mockInvestmentResponseDto);
    });

    it('should return investments for a specific account', async () => {
      const result = await investmentsService.getAllInvestments(1);

      expect(MockInvestmentsRepository.createQueryBuilder).toHaveBeenCalledWith(
        'investment',
      );
      expect(mockQueryBuilder.leftJoinAndSelect).toHaveBeenCalledTimes(2);
      expect(mockQueryBuilder.where).toHaveBeenCalledWith(
        'account.id_cuenta = :accountId',
        { accountId: 1 },
      );
      expect(result).toHaveLength(2);
    });

    it('should handle errors properly', async () => {
      mockQueryBuilder.getMany.mockRejectedValueOnce(
        new Error('Database error'),
      );

      await expect(investmentsService.getAllInvestments()).rejects.toThrow(
        HttpException,
      );
    });
  });

  describe('getInvestmentById', () => {
    it('should return an investment by id', async () => {
      const result = await investmentsService.getInvestmentById(1);

      expect(MockInvestmentsRepository.findOne).toHaveBeenCalledWith({
        where: { idInvestment: 1 },
        relations: ['account', 'trading'],
      });
      expect(result).toEqual(mockInvestmentResponseDto);
    });

    it('should throw an exception when investment is not found', async () => {
      MockInvestmentsRepository.findOne.mockResolvedValueOnce(null);

      await expect(investmentsService.getInvestmentById(999)).rejects.toThrow(
        HttpException,
      );
    });

    it('should handle errors properly', async () => {
      MockInvestmentsRepository.findOne.mockRejectedValueOnce(
        new Error('Database error'),
      );

      await expect(investmentsService.getInvestmentById(1)).rejects.toThrow(
        HttpException,
      );
    });
  });

  describe('createInvestment', () => {
    it('should create a new investment successfully', async () => {
      const result =
        await investmentsService.createInvestment(createInvestmentDto);

      expect(MockAccountsRepository.findOne).toHaveBeenCalledWith({
        where: { id_cuenta: createInvestmentDto.account_id },
        relations: ['accounts_type'],
      });
      expect(MockTradingRepository.findOne).toHaveBeenCalledWith({
        where: { symbol: createInvestmentDto.symbol },
      });
      expect(MockAccountsRepository.save).toHaveBeenCalled();
      expect(MockInvestmentsRepository.create).toHaveBeenCalled();
      expect(MockInvestmentsRepository.save).toHaveBeenCalled();
      expect(result).toBeDefined();
    });

    it('should throw an exception when account is not found', async () => {
      await expect(
        investmentsService.createInvestment({
          ...createInvestmentDto,
          account_id: 999,
        }),
      ).rejects.toThrow('Cuenta no encontrada');
    });

    it('should throw an exception when account type is not investment', async () => {
      await expect(
        investmentsService.createInvestment({
          ...createInvestmentDto,
          account_id: 2,
        }),
      ).rejects.toThrow(
        'Solo las cuentas de tipo Inversiones pueden tener inversiones',
      );
    });

    it('should throw an exception when trading symbol is not found', async () => {
      await expect(
        investmentsService.createInvestment({
          ...createInvestmentDto,
          symbol: 'INVALID',
        }),
      ).rejects.toThrow('Activo de trading no encontrado');
    });

    it('should throw an exception when account balance is insufficient', async () => {
      await expect(
        investmentsService.createInvestment({
          ...createInvestmentDto,
          account_id: 3,
        }),
      ).rejects.toThrow('Saldo insuficiente para realizar la inversión');
    });
  });
});
