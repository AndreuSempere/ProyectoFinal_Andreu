import { Test, TestingModule } from '@nestjs/testing';
import { AccountsService } from './accounts.service';
import { Accounts } from './accounts.entity';
import { getRepositoryToken } from '@nestjs/typeorm';
import { UtilsService } from '../utils/utils.service';
import { HttpException } from '@nestjs/common';

const accountsArray = [
  {
    id_cuenta: 1,
    numero_cuenta: 1234567890123456,
    saldo: 1000,
    estado: 'active',
    description: 'Cuenta principal',
    icon: 'icon1.png',
    fecha_creacion: new Date('2023-01-01'),
    accounts_type: { id_type: 1, name: 'Corriente' },
    id_user: { id_user: 1, name: 'Federico' },
    credit_card: [],
    transactions: [],
    investments: []
  },
  {
    id_cuenta: 2,
    numero_cuenta: 2345678901234567,
    saldo: 2000,
    estado: 'active',
    description: 'Cuenta secundaria',
    icon: 'icon2.png',
    fecha_creacion: new Date('2023-02-01'),
    accounts_type: { id_type: 2, name: 'Ahorro' },
    id_user: { id_user: 1, name: 'Federico' },
    credit_card: [],
    transactions: [],
    investments: []
  },
  {
    id_cuenta: 3,
    numero_cuenta: 3456789012345678,
    saldo: 3000,
    estado: 'inactive',
    description: 'Cuenta inactiva',
    icon: 'icon3.png',
    fecha_creacion: new Date('2023-03-01'),
    accounts_type: { id_type: 1, name: 'Corriente' },
    id_user: { id_user: 2, name: 'Gonzalo' },
    credit_card: [],
    transactions: [],
    investments: []
  }
];

const oneAccount = {
  id_cuenta: 1,
  numero_cuenta: 1234567890123456,
  saldo: 1000,
  estado: 'active',
  description: 'Cuenta principal',
  icon: 'icon1.png',
  fecha_creacion: new Date('2023-01-01'),
  accounts_type: { id_type: 1, name: 'Corriente' },
  id_user: { id_user: 1, name: 'Federico' },
  credit_card: [],
  transactions: [],
  investments: []
};

const createAccountDto = {
  numero_cuenta: 1234567890123456,
  saldo: 1000,
  estado: 'active',
  description: 'Cuenta principal',
  icon: 'icon1.png',
  fecha_creacion: '2023-01-01',
  accounts_type: 1,
  id_user: 1
};

const updateAccountDto = {
  saldo: 1500,
  estado: 'active',
  description: 'Cuenta actualizada'
};

const mergeAccount = {
  id_cuenta: 1,
  numero_cuenta: 1234567890123456,
  saldo: 1500,
  estado: 'active',
  description: 'Cuenta actualizada',
  icon: 'icon1.png',
  fecha_creacion: new Date('2023-01-01'),
  accounts_type: { id_type: 1, name: 'Corriente' },
  id_user: { id_user: 1, name: 'Federico' },
  credit_card: [],
  transactions: [],
  investments: []
};

describe('AccountsService', () => {
  let accountsService: AccountsService;
  
  const mockQueryBuilder = {
    innerJoinAndSelect: jest.fn().mockReturnThis(),
    where: jest.fn().mockReturnThis(),
    getMany: jest.fn().mockResolvedValue([oneAccount, accountsArray[1]])
  };
  
  const MockAccountsRepository = {
    find: jest.fn(() => accountsArray),
    findOneBy: jest.fn(() => oneAccount),
    create: jest.fn(() => oneAccount),
    findOne: jest.fn().mockResolvedValue(oneAccount),
    delete: jest.fn().mockResolvedValue({ affected: 1 }),
    save: jest.fn(() => mergeAccount),
    merge: jest.fn(() => mergeAccount),
    createQueryBuilder: jest.fn().mockReturnValue(mockQueryBuilder)
  };
  
  const MockUtilsService = {
    convertJSONtoXML: jest.fn(json => `<xml>${json}</xml>`)
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AccountsService,
        {
          provide: UtilsService,
          useValue: MockUtilsService
        },
        {
          provide: getRepositoryToken(Accounts),
          useValue: MockAccountsRepository,
        },
      ],
    }).compile();

    accountsService = module.get<AccountsService>(AccountsService);
  });

  it('should be defined', () => {
    expect(accountsService).toBeDefined();
  });
  
  describe('getAccount', () => {
    it('should return an account when xml is not provided', async () => {
      const result = await accountsService.getAccount(1);
      expect(MockAccountsRepository.findOneBy).toHaveBeenCalledWith({ id_cuenta: 1 });
      expect(result).toEqual(oneAccount);
    });
    
    it('should return an XML string when xml is set to "true"', async () => {
      const result = await accountsService.getAccount(1, 'true');
      expect(MockAccountsRepository.findOneBy).toHaveBeenCalledWith({ id_cuenta: 1 });
      expect(MockUtilsService.convertJSONtoXML).toHaveBeenCalled();
      expect(typeof result).toBe('string');
    });
  });
  
  describe('getAccountAll', () => {
    it('should return all accounts when xml is not provided', async () => {
      const result = await accountsService.getAccountAll();
      expect(MockAccountsRepository.find).toHaveBeenCalledWith({
        relations: ['accounts_type', 'id_user']
      });
      expect(result).toEqual(accountsArray);
    });
    
    it('should return an XML string when xml is set to "true"', async () => {
      const result = await accountsService.getAccountAll('true');
      expect(MockAccountsRepository.find).toHaveBeenCalledWith({
        relations: ['accounts_type', 'id_user']
      });
      expect(MockUtilsService.convertJSONtoXML).toHaveBeenCalled();
      expect(typeof result).toBe('string');
    });
  });
  
  describe('getAccountsByUserId', () => {
    it('should return accounts for a specific user', async () => {
      const result = await accountsService.getAccountsByUserId(1);
      expect(mockQueryBuilder.innerJoinAndSelect).toHaveBeenCalledTimes(2);
      expect(mockQueryBuilder.where).toHaveBeenCalledWith('user.id_user = :userId', { userId: 1 });
      expect(result).toHaveLength(2);
    });
  });
  
  describe('createAccount', () => {
    it('should create a new account', async () => {
      const result = await accountsService.createAccount(createAccountDto);
      
      expect(MockAccountsRepository.create).toHaveBeenCalledWith({
        ...createAccountDto,
        accounts_type: { id_type: createAccountDto.accounts_type },
        id_user: { id_user: createAccountDto.id_user }
      });
      expect(MockAccountsRepository.save).toHaveBeenCalled();
      expect(result).toEqual({ message: 'Account creada' });
    });
  });
  
  describe('updateAccount', () => {
    it('should update an account', async () => {
      const result = await accountsService.updateAccount(1, updateAccountDto);
      
      expect(MockAccountsRepository.findOne).toHaveBeenCalledWith({
        where: { id_cuenta: 1 },
        relations: ['accounts_type', 'id_user']
      });
      expect(MockAccountsRepository.merge).toHaveBeenCalled();
      expect(MockAccountsRepository.save).toHaveBeenCalled();
      expect(result).toEqual(mergeAccount);
    });
    
    it('should throw an exception when account is not found', async () => {
      MockAccountsRepository.findOne.mockResolvedValueOnce(null);
      
      await expect(accountsService.updateAccount(999, updateAccountDto)).rejects.toThrow(HttpException);
    });
  });
  
  describe('deleteAccount', () => {
    it('should delete an account successfully', async () => {
      const result = await accountsService.deleteAccount(1);
      
      expect(MockAccountsRepository.delete).toHaveBeenCalledWith(1);
      expect(result).toEqual({ message: 'Account eliminado' });
    });
    
    it('should throw an exception when account is not found', async () => {
      MockAccountsRepository.delete.mockResolvedValueOnce({ affected: 0 });
      
      await expect(accountsService.deleteAccount(999)).rejects.toThrow(HttpException);
    });
  });
});
