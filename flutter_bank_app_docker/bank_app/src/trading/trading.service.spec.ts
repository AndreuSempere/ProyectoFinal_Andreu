import { Test, TestingModule } from '@nestjs/testing';
import { TradingService } from './trading.service';
import { TradingEntity } from './trading.entity';
import { getRepositoryToken } from '@nestjs/typeorm';
import { HttpException } from '@nestjs/common';

const tradingRecordsArray = [
  {
    idtrading: 1,
    type: 'Acción',
    name: 'Apple Inc.',
    symbol: 'AAPL',
    price: 150.25,
    recordedAt: new Date('2023-01-15')
  },
  {
    idtrading: 2,
    type: 'Acción',
    name: 'Microsoft Corporation',
    symbol: 'MSFT',
    price: 320.75,
    recordedAt: new Date('2023-01-15')
  },
  {
    idtrading: 3,
    type: 'Criptomoneda',
    name: 'Bitcoin',
    symbol: 'BTC',
    price: 45000.00,
    recordedAt: new Date('2023-01-15')
  }
];

const createTradingDto = {
  type: 'Acción',
  name: 'Tesla',
  symbol: 'TSLA',
  price: 200.50
};

describe('TradingService', () => {
  let tradingService: TradingService;
  
  const mockQueryBuilder = {
    orderBy: jest.fn().mockReturnThis(),
    limit: jest.fn().mockReturnThis(),
    where: jest.fn().mockReturnThis(),
    getMany: jest.fn().mockResolvedValue(tradingRecordsArray)
  };
  
  const MockTradingRepository = {
    createQueryBuilder: jest.fn().mockReturnValue(mockQueryBuilder),
    create: jest.fn(() => ({
      idtrading: 4,
      ...createTradingDto,
      recordedAt: expect.any(Date)
    })),
    save: jest.fn(entity => entity)
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TradingService,
        {
          provide: getRepositoryToken(TradingEntity),
          useValue: MockTradingRepository
        }
      ],
    }).compile();

    tradingService = module.get<TradingService>(TradingService);
  });

  it('should be defined', () => {
    expect(tradingService).toBeDefined();
  });
  
  describe('getAllLatestTradingRecords', () => {
    it('should return the latest trading records', async () => {
      const result = await tradingService.getAllLatestTradingRecords();
      
      expect(MockTradingRepository.createQueryBuilder).toHaveBeenCalledWith('trading');
      expect(mockQueryBuilder.orderBy).toHaveBeenCalledWith('trading.idtrading', 'DESC');
      expect(mockQueryBuilder.limit).toHaveBeenCalledWith(15);
      expect(result).toEqual(tradingRecordsArray);
    });
  });
  
  describe('getTradingRecordsByName', () => {
    it('should return trading records matching the name', async () => {
      const result = await tradingService.getTradingRecordsByName('Apple');
      
      expect(MockTradingRepository.createQueryBuilder).toHaveBeenCalledWith('trading');
      expect(mockQueryBuilder.where).toHaveBeenCalledWith('trading.name LIKE :name', { name: '%Apple%' });
      expect(result).toEqual(tradingRecordsArray);
    });
    
    it('should throw an exception when no records are found', async () => {
      mockQueryBuilder.getMany.mockResolvedValueOnce([]);
      
      await expect(tradingService.getTradingRecordsByName('NonExistent')).rejects.toThrow(HttpException);
    });
  });
  
  describe('createTradingRecord', () => {
    it('should create a new trading record', async () => {
      const result = await tradingService.createTradingRecord(createTradingDto);
      
      expect(MockTradingRepository.create).toHaveBeenCalledWith(createTradingDto);
      expect(MockTradingRepository.save).toHaveBeenCalled();
      expect(result).toEqual({ message: 'Registro de trading creado satisfactoriamente' });
    });
  });
});
