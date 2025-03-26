import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { AuthService } from '../Autentication/auth.service';
import { HttpException, HttpStatus, NotFoundException } from '@nestjs/common';
import { CreateUserDto, UpdateUserDto } from './user.dto';

describe('UsersController', () => {
  let controller: UsersController;
  let usersService: UsersService;
  let authService: AuthService;

  const mockUser = {
    id_user: 1,
    name: 'Federico',
    surname: 'Gonzalez',
    password: 'hashedPassword',
    email: 'federico@gmail.com',
    telf: '612345678',
    dni: '12345678Z',
    fecha_nacimiento: '17/07/2001',
    tokenExpiration: null,
    token: null,
    firebaseToken: null,
    accounts: []
  };

  const mockCreateUserDto: CreateUserDto = {
    name: 'Federico',
    surname: 'Gonzalez',
    password: '123456',
    email: 'federico@gmail.com',
    dni: '12345678Z',
    fecha_nacimiento: '17/07/2001'
  };

  const mockUpdateUserDto: UpdateUserDto = {
    name: 'Manuel',
    surname: 'Fernandez'
  };

  const mockUsersService = {
    getUser: jest.fn(),
    getUserByEmail: jest.fn(),
    createUser: jest.fn(),
    updateUser: jest.fn(),
    deleteUser: jest.fn(),
    validateUser: jest.fn()
  };

  const mockAuthService = {
    generateToken: jest.fn()
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UsersController],
      providers: [
        {
          provide: UsersService,
          useValue: mockUsersService
        },
        {
          provide: AuthService,
          useValue: mockAuthService
        }
      ],
    }).compile();

    controller = module.get<UsersController>(UsersController);
    usersService = module.get<UsersService>(UsersService);
    authService = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('getUser', () => {
    it('should return a user when valid ID is provided', async () => {
      mockUsersService.getUser.mockResolvedValue(mockUser);
      
      const result = await controller.getUser('1');
      
      expect(mockUsersService.getUser).toHaveBeenCalledWith(1, undefined);
      expect(result).toEqual(mockUser);
    });

    it('should return XML when xml parameter is true', async () => {
      const xmlOutput = '<xml>user data</xml>';
      mockUsersService.getUser.mockResolvedValue(xmlOutput);
      
      const result = await controller.getUser('1', 'true');
      
      expect(mockUsersService.getUser).toHaveBeenCalledWith(1, 'true');
      expect(result).toEqual(xmlOutput);
    });

    it('should throw BadRequest when ID is invalid', async () => {
      await expect(controller.getUser('invalid')).rejects.toThrow(HttpException);
      expect(mockUsersService.getUser).not.toHaveBeenCalled();
    });

    it('should throw NotFoundException when user is not found', async () => {
      mockUsersService.getUser.mockResolvedValue(null);
      
      await expect(controller.getUser('999')).rejects.toThrow(NotFoundException);
      expect(mockUsersService.getUser).toHaveBeenCalledWith(999, undefined);
    });
  });

  describe('findUserByEmail', () => {
    it('should return a user when valid email is provided', async () => {
      mockUsersService.getUserByEmail.mockResolvedValue(mockUser);
      
      const result = await controller.findUserByEmail('federico@gmail.com');
      
      expect(mockUsersService.getUserByEmail).toHaveBeenCalledWith('federico@gmail.com');
      expect(result).toEqual(mockUser);
    });

    it('should throw BadRequest when email is not provided', async () => {
      await expect(controller.findUserByEmail('')).rejects.toThrow(HttpException);
      expect(mockUsersService.getUserByEmail).not.toHaveBeenCalled();
    });

    it('should throw NotFoundException when user is not found', async () => {
      mockUsersService.getUserByEmail.mockResolvedValue(null);
      
      await expect(controller.findUserByEmail('nonexistent@gmail.com')).rejects.toThrow(NotFoundException);
      expect(mockUsersService.getUserByEmail).toHaveBeenCalledWith('nonexistent@gmail.com');
    });
  });

  describe('createUser', () => {
    it('should create a user successfully', async () => {
      mockUsersService.createUser.mockResolvedValue(mockUser);
      
      const result = await controller.createUser(mockCreateUserDto);
      
      expect(mockUsersService.createUser).toHaveBeenCalledWith(mockCreateUserDto);
      expect(result).toEqual(mockUser);
    });

    it('should throw BadRequest when creation fails', async () => {
      mockUsersService.createUser.mockRejectedValue(new Error('Failed to create user'));
      
      await expect(controller.createUser(mockCreateUserDto)).rejects.toThrow(HttpException);
      expect(mockUsersService.createUser).toHaveBeenCalledWith(mockCreateUserDto);
    });
  });

  describe('updateUser', () => {
    it('should update a user successfully', async () => {
      const updatedUser = { ...mockUser, ...mockUpdateUserDto };
      mockUsersService.updateUser.mockResolvedValue(updatedUser);
      
      const result = await controller.updateUser('1', mockUpdateUserDto);
      
      expect(mockUsersService.updateUser).toHaveBeenCalledWith({
        ...mockUpdateUserDto,
        id_user: 1
      });
      expect(result).toEqual(updatedUser);
    });

    it('should throw BadRequest when ID is invalid', async () => {
      await expect(controller.updateUser('invalid', mockUpdateUserDto)).rejects.toThrow(HttpException);
      expect(mockUsersService.updateUser).not.toHaveBeenCalled();
    });

    it('should throw NotFound when user does not exist', async () => {
      mockUsersService.updateUser.mockRejectedValue(new Error('User not found'));
      
      await expect(controller.updateUser('999', mockUpdateUserDto)).rejects.toThrow(HttpException);
      expect(mockUsersService.updateUser).toHaveBeenCalledWith({
        ...mockUpdateUserDto,
        id_user: 999
      });
    });
  });

  describe('deleteUser', () => {
    it('should delete a user successfully', async () => {
      mockUsersService.deleteUser.mockResolvedValue(undefined);
      
      const result = await controller.deleteUser('1');
      
      expect(mockUsersService.deleteUser).toHaveBeenCalledWith(1);
      expect(result).toBeUndefined();
    });

    it('should throw BadRequest when ID is invalid', async () => {
      await expect(controller.deleteUser('invalid')).rejects.toThrow(HttpException);
      expect(mockUsersService.deleteUser).not.toHaveBeenCalled();
    });

    it('should throw NotFound when user does not exist', async () => {
      mockUsersService.deleteUser.mockRejectedValue(new Error('User not found'));
      
      await expect(controller.deleteUser('999')).rejects.toThrow(HttpException);
      expect(mockUsersService.deleteUser).toHaveBeenCalledWith(999);
    });
  });

  describe('login', () => {
    it('should return token and isAdmin flag when credentials are valid', async () => {
      mockUsersService.validateUser.mockResolvedValue(mockUser);
      mockAuthService.generateToken.mockResolvedValue('jwt-token');
      
      const result = await controller.login('federico@gmail.com', '123456');
      
      expect(mockUsersService.validateUser).toHaveBeenCalledWith('federico@gmail.com', '123456');
      expect(mockAuthService.generateToken).toHaveBeenCalledWith(1, false);
      expect(result).toEqual({ token: 'jwt-token', isAdmin: false });
    });

    it('should set isAdmin to true for admin@gmail.com', async () => {
      mockUsersService.validateUser.mockResolvedValue({ ...mockUser, email: 'admin@gmail.com' });
      mockAuthService.generateToken.mockResolvedValue('admin-jwt-token');
      
      const result = await controller.login('admin@gmail.com', '123456');
      
      expect(mockUsersService.validateUser).toHaveBeenCalledWith('admin@gmail.com', '123456');
      expect(mockAuthService.generateToken).toHaveBeenCalledWith(1, true);
      expect(result).toEqual({ token: 'admin-jwt-token', isAdmin: true });
    });

    it('should throw BadRequest when email or password is missing', async () => {
      await expect(controller.login('', '123456')).rejects.toThrow(HttpException);
      await expect(controller.login('federico@gmail.com', '')).rejects.toThrow(HttpException);
      expect(mockUsersService.validateUser).not.toHaveBeenCalled();
    });

    it('should throw Unauthorized when credentials are invalid', async () => {
      mockUsersService.validateUser.mockResolvedValue(null);
      
      await expect(controller.login('federico@gmail.com', 'wrongpassword')).rejects.toThrow(HttpException);
      expect(mockUsersService.validateUser).toHaveBeenCalledWith('federico@gmail.com', 'wrongpassword');
      expect(mockAuthService.generateToken).not.toHaveBeenCalled();
    });
  });
});
