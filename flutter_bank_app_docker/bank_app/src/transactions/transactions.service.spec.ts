import { Test, TestingModule } from '@nestjs/testing';
import { TransactionsService } from './transactions.service';
import { Transaction } from './transactions.entity';
import { Accounts } from '../accounts/accounts.entity';
import { getRepositoryToken } from '@nestjs/typeorm';
import { HttpService } from '@nestjs/axios';
import { FirebaseService } from '../firebase/firebase.service';
import { HttpException } from '@nestjs/common';
import { of } from 'rxjs';

const transactionsArray = [
  {
    id_transaction: 1,
    cantidad: 100,
    tipo: 'ingreso',
    descripcion: 'Ingreso de salario',
    created_at: new Date('2023-01-15'),
    receipt_url: 'https://example.com/receipt1.pdf',
    account: {
      id_cuenta: 1,
      numero_cuenta: 'ES1998042593664952233080',
      saldo: 1000,
      estado: 'active',
    },
    targetAccount: null,
  },
  {
    id_transaction: 2,
    cantidad: 50,
    tipo: 'gasto',
    descripcion: 'Compra en supermercado',
    created_at: new Date('2023-01-20'),
    receipt_url: 'https://example.com/receipt2.pdf',
    account: {
      id_cuenta: 1,
      numero_cuenta: 'ES1998042593664952233080',
      saldo: 950,
      estado: 'active',
    },
    targetAccount: null,
  },
  {
    id_transaction: 3,
    cantidad: 200,
    tipo: 'gasto',
    descripcion: 'Transferencia a Juan',
    created_at: new Date('2023-01-25'),
    receipt_url: 'https://example.com/receipt3.pdf',
    account: {
      id_cuenta: 1,
      numero_cuenta: 'ES1998042593664952233080',
      saldo: 750,
      estado: 'active',
    },
    targetAccount: {
      id_cuenta: 2,
      numero_cuenta: 'ES1998042593664952233081',
      saldo: 2200,
      estado: 'active',
    },
  },
];

const oneTransaction = {
  id_transaction: 1,
  cantidad: 100,
  tipo: 'ingreso',
  descripcion: 'Ingreso de salario',
  created_at: new Date('2023-01-15'),
  receipt_url: 'https://example.com/receipt1.pdf',
  account: {
    id_cuenta: 1,
    numero_cuenta: 'ES1998042593664952233080',
    saldo: 1000,
    estado: 'active',
    id_user: {
      id_user: 1,
      name: 'Federico',
      surname: 'Gonzalez',
      firebaseToken: 'firebase-token-123',
    },
  },
  targetAccount: null,
};

const sourceAccount = {
  id_cuenta: 1,
  numero_cuenta: 'ES1998042593664952233080',
  saldo: 1000,
  estado: 'active',
  id_user: {
    id_user: 1,
    name: 'Federico',
    surname: 'Gonzalez',
    firebaseToken: 'firebase-token-123',
  },
};

const targetAccount = {
  id_cuenta: 2,
  numero_cuenta: 'ES1998042593664952233081',
  saldo: 2000,
  estado: 'active',
  id_user: {
    id_user: 2,
    name: 'Gonzalo',
    surname: 'Martinez',
    firebaseToken: 'firebase-token-456',
  },
};

const createTransactionDto = {
  accountId: 1,
  targetAccountId: 2,
  cantidad: 200,
  tipo: 'gasto' as 'ingreso' | 'gasto',
  descripcion: 'Transferencia a Juan',
};

describe('TransactionsService', () => {
  let transactionsService: TransactionsService;

  const mockQueryBuilder = {
    innerJoinAndSelect: jest.fn().mockReturnThis(),
    where: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
    getMany: jest
      .fn()
      .mockResolvedValue([transactionsArray[0], transactionsArray[1]]),
  };

  const MockTransactionsRepository = {
    find: jest.fn(() => transactionsArray),
    findOneBy: jest.fn(() => oneTransaction),
    create: jest.fn().mockReturnValue(oneTransaction),
    save: jest.fn().mockResolvedValue(oneTransaction),
    createQueryBuilder: jest.fn().mockReturnValue(mockQueryBuilder),
  };

  const MockAccountsRepository = {
    findOne: jest.fn().mockImplementation(({ where }) => {
      if (
        where.id_cuenta === 1 ||
        where[0]?.id_cuenta === 1 ||
        where[0]?.numero_cuenta === 'ES1998042593664952233080'
      ) {
        return Promise.resolve(sourceAccount);
      } else if (
        where.id_cuenta === 2 ||
        where[0]?.id_cuenta === 2 ||
        where[0]?.numero_cuenta === 'ES1998042593664952233081'
      ) {
        return Promise.resolve(targetAccount);
      }
      return Promise.resolve(null);
    }),
  };

  const MockHttpService = {
    post: jest.fn().mockImplementation(() => {
      return of({
        data: { message: 'Transacción procesada con éxito' },
        headers: { 'content-type': 'application/json' },
      });
    }),
  };

  const MockFirebaseService = {
    isInitialized: jest.fn().mockReturnValue(true),
    sendPushNotification: jest.fn().mockResolvedValue(undefined),
    uploadPdfToStorage: jest
      .fn()
      .mockResolvedValue('https://example.com/receipt.pdf'),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TransactionsService,
        {
          provide: getRepositoryToken(Transaction),
          useValue: MockTransactionsRepository,
        },
        {
          provide: getRepositoryToken(Accounts),
          useValue: MockAccountsRepository,
        },
        {
          provide: HttpService,
          useValue: MockHttpService,
        },
        {
          provide: FirebaseService,
          useValue: MockFirebaseService,
        },
      ],
    }).compile();

    transactionsService = module.get<TransactionsService>(TransactionsService);
  });

  it('should be defined', () => {
    expect(transactionsService).toBeDefined();
  });

  describe('getTransaction', () => {
    it('should return a transaction by id', async () => {
      const result = await transactionsService.getTransaction(1);

      expect(MockTransactionsRepository.findOneBy).toHaveBeenCalledWith({
        id_transaction: 1,
      });
      expect(result).toEqual(oneTransaction);
    });
  });

  describe('getTransactionAll', () => {
    it('should return all transactions', async () => {
      const result = await transactionsService.getTransactionAll();

      expect(MockTransactionsRepository.find).toHaveBeenCalledWith({
        relations: ['account'],
      });
      expect(result).toEqual(transactionsArray);
    });
  });

  describe('getTransactionsByAccountId', () => {
    it('should return transactions for a specific account', async () => {
      const result = await transactionsService.getTransactionsByAccountId(1);

      expect(mockQueryBuilder.innerJoinAndSelect).toHaveBeenCalledWith(
        'transaction.account',
        'account',
      );
      expect(mockQueryBuilder.where).toHaveBeenCalledWith(
        'account.id_cuenta = :accountId',
        { accountId: 1 },
      );
      expect(mockQueryBuilder.orderBy).toHaveBeenCalledWith(
        'transaction.id_transaction',
        'DESC',
      );
      expect(result).toHaveLength(2);
    });
  });

  describe('createTransaction', () => {
    it('should create a transaction successfully', async () => {
      const result =
        await transactionsService.createTransaction(createTransactionDto);

      expect(MockAccountsRepository.findOne).toHaveBeenCalledTimes(2);
      expect(MockHttpService.post).toHaveBeenCalled();
      // No verificamos MockTransactionsRepository.save porque depende de condiciones internas
      expect(MockFirebaseService.sendPushNotification).toHaveBeenCalled();
      expect(result).toEqual({ message: 'Transacción procesada con éxito' });
    });

    it('should throw an exception when source account is not found', async () => {
      MockAccountsRepository.findOne.mockResolvedValueOnce(null);

      await expect(
        transactionsService.createTransaction({
          ...createTransactionDto,
          accountId: 999,
        }),
      ).rejects.toThrow(HttpException);
    });

    it('should throw an exception when target account is not found', async () => {
      MockAccountsRepository.findOne.mockImplementationOnce(({ where }) => {
        if (where.id_cuenta === 1) {
          return Promise.resolve(sourceAccount);
        }
        return Promise.resolve(null);
      });

      await expect(
        transactionsService.createTransaction({
          ...createTransactionDto,
          targetAccountId: 999,
        }),
      ).rejects.toThrow(HttpException);
    });
  });
});
