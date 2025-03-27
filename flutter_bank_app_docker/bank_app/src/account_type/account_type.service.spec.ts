import { Test, TestingModule } from '@nestjs/testing';
import { AccountTypeService } from './account_type.service';
import { Accounts_type } from './account_type.entity';
import { getRepositoryToken } from '@nestjs/typeorm';
import { UtilsService } from '../utils/utils.service';
import { HttpException } from '@nestjs/common';

const accountTypesArray = [
  {
    id_type: 1,
    description: 'Cuenta Corriente',
    accounts: [],
  },
  {
    id_type: 2,
    description: 'Cuenta de Ahorro',
    accounts: [],
  },
  {
    id_type: 3,
    description: 'Cuenta de Inversiones',
    accounts: [],
  },
];

const oneAccountType = accountTypesArray[0];

const createAccountTypeDto = {
  description: 'Nueva Cuenta',
};

const updateAccountTypeDto = {
  id_type: 1,
  description: 'Cuenta Corriente Actualizada',
};

describe('AccountTypeService', () => {
  let accountTypeService: AccountTypeService;

  const MockAccountTypeRepository = {
    find: jest.fn(() => accountTypesArray),
    findOne: jest.fn(({ where }) => {
      if (where.id_type === 1) {
        return Promise.resolve(oneAccountType);
      }
      return Promise.resolve(null);
    }),
    create: jest.fn(() => ({
      id_type: 4,
      description: createAccountTypeDto.description,
      accounts: [],
    })),
    save: jest.fn((entity) => entity),
    update: jest.fn().mockResolvedValue({ affected: 1 }),
    delete: jest.fn((id) => {
      if (id === 1) {
        return Promise.resolve({ affected: 1 });
      }
      return Promise.resolve({ affected: 0 });
    }),
  };

  const MockUtilsService = {
    convertJSONtoXML: jest.fn((json) => `<xml>${json}</xml>`),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AccountTypeService,
        {
          provide: getRepositoryToken(Accounts_type),
          useValue: MockAccountTypeRepository,
        },
        {
          provide: UtilsService,
          useValue: MockUtilsService,
        },
      ],
    }).compile();

    accountTypeService = module.get<AccountTypeService>(AccountTypeService);
  });

  it('should be defined', () => {
    expect(accountTypeService).toBeDefined();
  });

  describe('getAllAccountType', () => {
    it('should return all account types', async () => {
      const result = await accountTypeService.getAllAccountType();

      expect(MockAccountTypeRepository.find).toHaveBeenCalled();
      expect(result).toEqual(accountTypesArray);
    });

    it('should return XML when format is xml', async () => {
      const result = await accountTypeService.getAllAccountType('xml');

      expect(MockAccountTypeRepository.find).toHaveBeenCalled();
      expect(MockUtilsService.convertJSONtoXML).toHaveBeenCalled();
      expect(typeof result).toBe('string');
    });
  });

  describe('getAccountType', () => {
    it('should return an account type by id', async () => {
      const result = await accountTypeService.getAccountType(1);

      expect(MockAccountTypeRepository.findOne).toHaveBeenCalledWith({
        where: { id_type: 1 },
      });
      expect(result).toEqual(oneAccountType);
    });

    it('should return XML when format is xml', async () => {
      const result = await accountTypeService.getAccountType(1, 'xml');

      expect(MockAccountTypeRepository.findOne).toHaveBeenCalledWith({
        where: { id_type: 1 },
      });
      expect(MockUtilsService.convertJSONtoXML).toHaveBeenCalled();
      expect(typeof result).toBe('string');
    });

    it('should throw an exception when account type is not found', async () => {
      MockAccountTypeRepository.findOne.mockResolvedValueOnce(null);

      await expect(accountTypeService.getAccountType(999)).rejects.toThrow(
        HttpException,
      );
    });
  });

  describe('createAccountType', () => {
    it('should create a new account type', async () => {
      const result =
        await accountTypeService.createAccountType(createAccountTypeDto);

      expect(MockAccountTypeRepository.create).toHaveBeenCalledWith({
        description: createAccountTypeDto.description,
      });
      expect(MockAccountTypeRepository.save).toHaveBeenCalled();
      expect(result).toEqual({
        message: 'Tipo de cuenta creado satisfactoriamente',
      });
    });
  });

  describe('updateAccountType', () => {
    it('should update an account type', async () => {
      await accountTypeService.updateAccountType(updateAccountTypeDto);

      expect(MockAccountTypeRepository.findOne).toHaveBeenCalledWith({
        where: { id_type: updateAccountTypeDto.id_type },
      });
      expect(MockAccountTypeRepository.update).toHaveBeenCalledWith(
        updateAccountTypeDto.id_type,
        updateAccountTypeDto,
      );
      expect(MockAccountTypeRepository.findOne).toHaveBeenCalledTimes(2);
    });

    it('should throw an exception when account type is not found', async () => {
      MockAccountTypeRepository.findOne.mockResolvedValueOnce(null);

      await expect(
        accountTypeService.updateAccountType({
          id_type: 999,
          description: 'No existe',
        }),
      ).rejects.toThrow(HttpException);
    });
  });

  describe('deleteAccountType', () => {
    it('should delete an account type successfully', async () => {
      const result = await accountTypeService.deleteAccountType(1);

      expect(MockAccountTypeRepository.delete).toHaveBeenCalledWith(1);
      expect(result).toEqual({
        message: 'Tipo de cuenta eliminado satisfactoriamente',
      });
    });

    it('should throw an exception when account type is not found', async () => {
      await expect(accountTypeService.deleteAccountType(999)).rejects.toThrow(
        HttpException,
      );
    });
  });
});
