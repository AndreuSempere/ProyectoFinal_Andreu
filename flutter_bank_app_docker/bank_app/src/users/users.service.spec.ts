import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import { User } from './users.entity';
import { getRepositoryToken } from '@nestjs/typeorm';
import { UtilsService } from '../utils/utils.service';
import { FirebaseService } from '../firebase/firebase.service';
import { HttpException } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';

jest.mock('bcryptjs', () => ({
  hash: jest
    .fn()
    .mockResolvedValue(
      '$2a$10$KqzrUgLlKotrrHiZHgPrZenAwlJlJRdYSm5HH1ge3ZqQFmUJyme/m',
    ),
  compare: jest.fn().mockResolvedValue(true),
}));

const usersArray = [
  {
    id_user: 1,
    name: 'Federico',
    surname: 'Gonzalez',
    password: '123456',
    email: 'federico@gmail.com',
    telf: '612345678',
    dni: '12345678Z',
    fecha_nacimiento: '17/07/2001',
    tokenExpiration: null,
    token: null,
    firebaseToken: null,
    accounts: [],
  },
  {
    id_user: 2,
    name: 'Gonzalo',
    surname: 'Martinez',
    password: '123456',
    email: 'gonzalo@gmail.com',
    telf: '623456789',
    dni: '23456789X',
    fecha_nacimiento: '20/05/1995',
    tokenExpiration: null,
    token: null,
    firebaseToken: null,
    accounts: [],
  },
  {
    id_user: 3,
    name: 'Gustavo',
    surname: 'Messi',
    password: '123456',
    email: 'gustavo@gmail.com',
    telf: '634567890',
    dni: '34567890Y',
    fecha_nacimiento: '10/01/1990',
    tokenExpiration: null,
    token: null,
    firebaseToken: null,
    accounts: [],
  },
];

const oneUser = {
  id_user: 1,
  name: 'Federico',
  surname: 'Gonzalez',
  password: '$2a$10$KqzrUgLlKotrrHiZHgPrZenAwlJlJRdYSm5HH1ge3ZqQFmUJyme/m',
  email: 'federico@gmail.com',
  telf: '612345678',
  dni: '12345678Z',
  fecha_nacimiento: '17/07/2001',
  tokenExpiration: null,
  token: null,
  firebaseToken: null,
  accounts: [],
};

const getOneUser = {
  id_user: 1,
  name: 'Federico',
  surname: 'Gonzalez',
  password: '$2a$10$KqzrUgLlKotrrHiZHgPrZenAwlJlJRdYSm5HH1ge3ZqQFmUJyme/m',
  email: 'federico@gmail.com',
  telf: '612345678',
  dni: '12345678Z',
  fecha_nacimiento: '17/07/2001',
  tokenExpiration: null,
  token: null,
  firebaseToken: null,
  accounts: [],
};

const createUserDto = {
  name: 'Federico',
  surname: 'Gonzalez',
  password: '123456',
  email: 'federico@gmail.com',
  telf: '612345678',
  dni: '12345678Z',
  fecha_nacimiento: '17/07/2001',
};

const updateUserDto = {
  id_user: 1,
  name: 'Manuel',
  surname: 'Fernandez',
  telf: '698765432',
};

const updatedUser = {
  id_user: 1,
  name: 'Manuel',
  surname: 'Fernandez',
  password: 'hashedPassword',
  email: 'federico@gmail.com',
  telf: '698765432',
  dni: '12345678Z',
  fecha_nacimiento: '17/07/2001',
  tokenExpiration: null,
  token: null,
  firebaseToken: 'firebase-token-123',
  accounts: [],
};

describe('UsersService', () => {
  let userService: UsersService;

  const mockQueryBuilder = {
    where: jest.fn().mockReturnThis(),
    getOne: jest.fn().mockResolvedValue(oneUser),
  };

  const MockUsersRepository = {
    find: jest.fn(() => usersArray),
    findOneBy: jest.fn().mockResolvedValue(oneUser),
    create: jest.fn().mockReturnValue(oneUser),
    findOne: jest.fn().mockResolvedValue(getOneUser),
    delete: jest.fn().mockResolvedValue(undefined),
    save: jest.fn().mockImplementation((user) => Promise.resolve(user)),
    merge: jest.fn().mockImplementation((user, dto) => {
      return { ...user, ...dto };
    }),
    createQueryBuilder: jest.fn().mockReturnValue(mockQueryBuilder),
  };

  const MockUtilsService = {
    convertJSONtoXML: jest.fn((json) => `<xml>${json}</xml>`),
  };

  const MockFirebaseService = {
    sendPushNotification: jest.fn().mockResolvedValue(undefined),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: UtilsService,
          useValue: MockUtilsService,
        },
        {
          provide: FirebaseService,
          useValue: MockFirebaseService,
        },
        {
          provide: getRepositoryToken(User),
          useValue: MockUsersRepository,
        },
      ],
    }).compile();

    userService = module.get<UsersService>(UsersService);
  });

  it('should be defined', () => {
    expect(userService).toBeDefined();
  });

  describe('createUser', () => {
    it('should create a new user with hashed password', async () => {
      const result = await userService.createUser(createUserDto);

      expect(MockUsersRepository.create).toHaveBeenCalledWith(createUserDto);
      expect(bcrypt.hash).toHaveBeenCalledWith(createUserDto.password, 10);
      expect(MockUsersRepository.save).toHaveBeenCalled();
      expect(result).toEqual(oneUser);
    });
  });

  describe('getUser', () => {
    it('should return a user when xml is not provided', async () => {
      const result = await userService.getUser(1);

      expect(MockUsersRepository.findOneBy).toHaveBeenCalledWith({
        id_user: 1,
      });
      expect(result).toEqual(oneUser);
    });

    it('should return an XML string when xml is set to "true"', async () => {
      const result = await userService.getUser(1, 'true');

      expect(MockUsersRepository.findOneBy).toHaveBeenCalledWith({
        id_user: 1,
      });
      expect(MockUtilsService.convertJSONtoXML).toHaveBeenCalled();
      expect(typeof result).toBe('string');
    });

    it('should throw an exception when user is not found', async () => {
      MockUsersRepository.findOneBy.mockResolvedValueOnce(null);

      await expect(userService.getUser(999)).rejects.toThrow(HttpException);
    });
  });

  describe('updateUser', () => {
    it('should update a user successfully', async () => {
      const result = await userService.updateUser(updateUserDto);

      expect(MockUsersRepository.findOne).toHaveBeenCalledWith({
        where: { id_user: updateUserDto.id_user },
      });
      expect(MockUsersRepository.merge).toHaveBeenCalled();
      expect(MockUsersRepository.save).toHaveBeenCalled();
      expect(result).toBeDefined();
    });

    it('should throw an error when user is not found', async () => {
      MockUsersRepository.findOne.mockResolvedValueOnce(null);

      await expect(userService.updateUser(updateUserDto)).rejects.toThrow(
        'Usuario no encontrado',
      );
    });

    it('should send push notification when telephone number is changed and firebase token exists', async () => {
      MockUsersRepository.findOne.mockResolvedValueOnce({
        ...oneUser,
        firebaseToken: 'firebase-token-123',
      });

      MockUsersRepository.save.mockResolvedValueOnce(updatedUser);
      const result = await userService.updateUser(updateUserDto);

      expect(MockFirebaseService.sendPushNotification).toHaveBeenCalledWith(
        'firebase-token-123',
        'Has añadido tu número de telefono',
        `El numero añadido es ${updateUserDto.telf}`,
      );
      expect(result).toEqual(updatedUser);
    });
  });

  describe('deleteUser', () => {
    it('should delete a user successfully', async () => {
      await userService.deleteUser(1);

      expect(MockUsersRepository.delete).toHaveBeenCalledWith(1);
    });
  });

  describe('validateUser', () => {
    it('should return user when credentials are valid', async () => {
      const result = await userService.validateUser(
        'federico@gmail.com',
        '123456',
      );

      expect(MockUsersRepository.findOne).toHaveBeenCalledWith({
        where: { email: 'federico@gmail.com' },
      });
      expect(bcrypt.compare).toHaveBeenCalledWith('123456', expect.any(String));
      expect(result).toEqual(oneUser);
    });

    it('should return null when credentials are invalid', async () => {
      // Mock bcrypt.compare para devolver false
      (bcrypt.compare as jest.Mock).mockResolvedValueOnce(false);

      const result = await userService.validateUser(
        'federico@gmail.com',
        'wrongpassword',
      );

      expect(result).toBeNull();
    });

    it('should return null when user is not found', async () => {
      MockUsersRepository.findOne.mockResolvedValueOnce(null);

      const result = await userService.validateUser(
        'nonexistent@gmail.com',
        '123456',
      );

      expect(result).toBeNull();
    });
  });

  describe('getUserByEmail', () => {
    it('should return a user by email', async () => {
      const result = await userService.getUserByEmail('federico@gmail.com');

      expect(mockQueryBuilder.where).toHaveBeenCalledWith(
        'u.email LIKE :email',
        {
          email: 'federico@gmail.com',
        },
      );
      expect(result).toEqual(oneUser);
    });
  });
});
