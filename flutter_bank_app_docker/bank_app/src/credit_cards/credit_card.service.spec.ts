import { Test, TestingModule } from '@nestjs/testing';
import { Credit_CardService } from './credit_card.service';
import { Credit_Card } from './credit_card.entity';
import { Accounts } from '../accounts/accounts.entity';
import { getRepositoryToken } from '@nestjs/typeorm';
import { UtilsService } from '../utils/utils.service';
import { HttpException, NotFoundException } from '@nestjs/common';
import { Not } from 'typeorm';

const creditCardsArray = [
  {
    id_tarjeta: 1,
    numero_tarjeta: 1234567890123456,
    tipo_tarjeta: 'Visa',
    cardHolderName: 'Federico Gonzalez',
    fecha_expiracion: '2025-12-31',
    cvv: 123,
    color: 1,
    accounts: {
      id_cuenta: 1,
      numero_cuenta: 1234567890123456,
      saldo: 1000
    }
  },
  {
    id_tarjeta: 2,
    numero_tarjeta: 2345678901234567,
    tipo_tarjeta: 'MasterCard',
    cardHolderName: 'Gonzalo Martinez',
    fecha_expiracion: '2026-06-30',
    cvv: 456,
    color: 2,
    accounts: {
      id_cuenta: 2,
      numero_cuenta: 2345678901234567,
      saldo: 2000
    }
  },
  {
    id_tarjeta: 3,
    numero_tarjeta: 3456789012345678,
    tipo_tarjeta: 'American Express',
    cardHolderName: 'Federico Gonzalez',
    fecha_expiracion: '2024-09-30',
    cvv: 789,
    color: 3,
    accounts: {
      id_cuenta: 1,
      numero_cuenta: 1234567890123456,
      saldo: 1000
    }
  }
];

const oneCreditCard = creditCardsArray[0];

const createCreditCardDto = {
  numero_tarjeta: 4567890123456789,
  tipo_tarjeta: 'Visa',
  cardHolderName: 'Nuevo Usuario',
  fecha_expiracion: '2027-01-31',
  cvv: 321,
  color: 4,
  id_cuenta: 1
};

const updateCreditCardDto = {
  tipo_tarjeta: 'MasterCard',
  fecha_expiracion: '2028-01-31',
  color: 5
};

const updatedCreditCard = {
  ...oneCreditCard,
  tipo_tarjeta: 'MasterCard',
  fecha_expiracion: '2028-01-31',
  color: 5
};

describe('Credit_CardService', () => {
  let creditCardService: Credit_CardService;
  
  const MockCreditCardRepository = {
    find: jest.fn(() => creditCardsArray),
    findOne: jest.fn(({ where }) => {
      if (where.id_tarjeta === 1) {
        return Promise.resolve(oneCreditCard);
      } else if (where.numero_tarjeta === 1234567890123456) {
        return Promise.resolve(oneCreditCard);
      } else if (where.numero_tarjeta === 4567890123456789) {
        return Promise.resolve(null);
      } else if (where.numero_tarjeta === 2345678901234567 && where.id_tarjeta !== 2) {
        return Promise.resolve(creditCardsArray[1]);
      }
      return Promise.resolve(null);
    }),
    create: jest.fn(() => ({
      ...createCreditCardDto,
      id_tarjeta: 4,
      accounts: { id_cuenta: createCreditCardDto.id_cuenta }
    })),
    save: jest.fn(entity => entity),
    merge: jest.fn((oldEntity, newEntity) => ({
      ...oldEntity,
      ...newEntity
    })),
    delete: jest.fn(id => {
      if (id === 1) {
        return Promise.resolve({ affected: 1 });
      }
      return Promise.resolve({ affected: 0 });
    })
  };
  
  const MockAccountsRepository = {
    findOne: jest.fn(({ where }) => {
      if (where.id_cuenta === 1) {
        return Promise.resolve({
          id_cuenta: 1,
          numero_cuenta: 1234567890123456,
          saldo: 1000
        });
      }
      return Promise.resolve(null);
    })
  };
  
  const MockUtilsService = {
    convertJSONtoXML: jest.fn(json => `<xml>${json}</xml>`)
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        Credit_CardService,
        {
          provide: getRepositoryToken(Credit_Card),
          useValue: MockCreditCardRepository
        },
        {
          provide: getRepositoryToken(Accounts),
          useValue: MockAccountsRepository
        },
        {
          provide: UtilsService,
          useValue: MockUtilsService
        }
      ],
    }).compile();

    creditCardService = module.get<Credit_CardService>(Credit_CardService);
  });

  it('should be defined', () => {
    expect(creditCardService).toBeDefined();
  });
  
  describe('getidCreditCard', () => {
    it('should return a credit card by id', async () => {
      const result = await creditCardService.getidCreditCard(1);
      
      expect(MockCreditCardRepository.findOne).toHaveBeenCalledWith({
        where: { id_tarjeta: 1 },
        relations: ['accounts']
      });
      expect(result).toEqual(oneCreditCard);
    });
    
    it('should return an XML string when xml is set to "true"', async () => {
      const result = await creditCardService.getidCreditCard(1, 'true');
      
      expect(MockCreditCardRepository.findOne).toHaveBeenCalledWith({
        where: { id_tarjeta: 1 },
        relations: ['accounts']
      });
      expect(MockUtilsService.convertJSONtoXML).toHaveBeenCalled();
      expect(typeof result).toBe('string');
    });
    
    it('should throw an exception when credit card is not found', async () => {
      MockCreditCardRepository.findOne.mockResolvedValueOnce(null);
      
      await expect(creditCardService.getidCreditCard(999)).rejects.toThrow(HttpException);
    });
  });
  
  describe('getCreditCard', () => {
    it('should return a credit card by number', async () => {
      const result = await creditCardService.getCreditCard(1234567890123456);
      
      expect(MockCreditCardRepository.findOne).toHaveBeenCalledWith({
        where: { numero_tarjeta: 1234567890123456 },
        relations: ['accounts']
      });
      expect(result).toEqual(oneCreditCard);
    });
    
    it('should throw an exception when credit card is not found', async () => {
      MockCreditCardRepository.findOne.mockResolvedValueOnce(null);
      
      await expect(creditCardService.getCreditCard(9999999999999999)).rejects.toThrow();
    });
  });
  
  describe('getAllCreditCards', () => {
    it('should return all credit cards', async () => {
      const result = await creditCardService.getAllCreditCards();
      
      expect(MockCreditCardRepository.find).toHaveBeenCalledWith({
        relations: ['accounts']
      });
      expect(result).toEqual(creditCardsArray);
    });
    
    it('should return an XML string when xml is set to "true"', async () => {
      const result = await creditCardService.getAllCreditCards('true');
      
      expect(MockCreditCardRepository.find).toHaveBeenCalledWith({
        relations: ['accounts']
      });
      expect(MockUtilsService.convertJSONtoXML).toHaveBeenCalled();
      expect(typeof result).toBe('string');
    });
  });
  
  describe('createCreditCard', () => {
    it('should create a new credit card', async () => {
      const result = await creditCardService.createCreditCard(createCreditCardDto);
      
      expect(MockCreditCardRepository.findOne).toHaveBeenCalledWith({
        where: { numero_tarjeta: createCreditCardDto.numero_tarjeta }
      });
      expect(MockAccountsRepository.findOne).toHaveBeenCalledWith({
        where: { id_cuenta: createCreditCardDto.id_cuenta }
      });
      expect(MockCreditCardRepository.create).toHaveBeenCalledWith({
        ...createCreditCardDto,
        accounts: { id_cuenta: createCreditCardDto.id_cuenta }
      });
      expect(MockCreditCardRepository.save).toHaveBeenCalled();
      expect(result).toEqual({ message: 'Tarjeta de crédito creada exitosamente' });
    });
    
    it('should throw an exception when credit card number already exists', async () => {
      MockCreditCardRepository.findOne.mockResolvedValueOnce(oneCreditCard);
      
      await expect(creditCardService.createCreditCard({
        ...createCreditCardDto,
        numero_tarjeta: 1234567890123456
      })).rejects.toThrow(HttpException);
    });
    
    it('should throw an exception when account does not exist', async () => {
      MockAccountsRepository.findOne.mockResolvedValueOnce(null);
      
      await expect(creditCardService.createCreditCard({
        ...createCreditCardDto,
        id_cuenta: 999
      })).rejects.toThrow(HttpException);
    });
  });
  
  describe('updateCreditCard', () => {
    it('should update a credit card', async () => {
      const result = await creditCardService.updateCreditCard(1, updateCreditCardDto);
      
      expect(MockCreditCardRepository.findOne).toHaveBeenCalledWith({
        where: { id_tarjeta: 1 },
        relations: ['accounts']
      });
      expect(MockCreditCardRepository.merge).toHaveBeenCalled();
      expect(MockCreditCardRepository.save).toHaveBeenCalled();
      expect(result).toEqual(updatedCreditCard);
    });
    
    it('should throw an exception when credit card is not found', async () => {
      MockCreditCardRepository.findOne.mockResolvedValueOnce(null);
      
      await expect(creditCardService.updateCreditCard(999, updateCreditCardDto)).rejects.toThrow(HttpException);
    });
    
    it('should throw an exception when new card number already exists', async () => {
      const dto = { ...updateCreditCardDto, numero_tarjeta: 2345678901234567 };
      
      await expect(creditCardService.updateCreditCard(1, dto)).rejects.toThrow(HttpException);
    });
  });
  
  describe('deleteCreditCard', () => {
    it('should delete a credit card successfully', async () => {
      const result = await creditCardService.deleteCreditCard(1);
      
      expect(MockCreditCardRepository.delete).toHaveBeenCalledWith(1);
      expect(result).toEqual({ message: 'Tarjeta eliminada exitosamente' });
    });
    
    it('should throw an exception when credit card is not found', async () => {
      await expect(creditCardService.deleteCreditCard(999)).rejects.toThrow(HttpException);
    });
  });
});
