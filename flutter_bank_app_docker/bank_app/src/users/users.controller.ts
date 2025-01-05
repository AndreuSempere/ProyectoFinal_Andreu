import {
  Body,
  Controller,
  Delete,
  Get,
  HttpException,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto, UpdateUserDto } from './user.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  getAllUser(@Query('xml') xml?: string) {
    try {
      return this.usersService.getAllUser(xml);
    } catch (err) {
      throw new HttpException(
        {
          status: HttpStatus.INTERNAL_SERVER_ERROR,
          error: err.message || 'Internal Server Error',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  async getUser(@Param('id') id: string, @Query('xml') xml?: string) {
    const userId = parseInt(id, 10);
    if (isNaN(userId)) {
      throw new HttpException('Invalid user ID', HttpStatus.BAD_REQUEST);
    }
    const user = await this.usersService.getUser(userId, xml);
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return user;
  }

  @Get('user/:email')
  async findUserByEmail(@Param('email') email: string) {
    if (!email) {
      throw new HttpException('Email is required', HttpStatus.BAD_REQUEST);
    }
    const user = await this.usersService.getUserByEmail(email);
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return user;
  }

  @Post()
  async createUser(@Body() createUserDto: CreateUserDto) {
    try {
      return await this.usersService.createUser(createUserDto);
    } catch (err) {
      throw new HttpException(
        {
          status: HttpStatus.BAD_REQUEST,
          error: err.message || 'Failed to create user',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put(':id')
  async updateUser(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    const userId = parseInt(id, 10);
    if (isNaN(userId)) {
      throw new HttpException('Invalid user ID', HttpStatus.BAD_REQUEST);
    }
    try {
      return await this.usersService.updateUser({
        ...updateUserDto,
        id_user: userId,
      });
    } catch (err) {
      throw new HttpException(
        {
          status: HttpStatus.NOT_FOUND,
          error: err.message || 'User not found',
        },
        HttpStatus.NOT_FOUND,
      );
    }
  }

  @Delete(':id')
  async deleteUser(@Param('id') id: string) {
    const userId = parseInt(id, 10);
    if (isNaN(userId)) {
      throw new HttpException('Invalid user ID', HttpStatus.BAD_REQUEST);
    }
    try {
      return await this.usersService.deleteUser(userId);
    } catch (err) {
      throw new HttpException(
        {
          status: HttpStatus.NOT_FOUND,
          error: err.message || 'User not found',
        },
        HttpStatus.NOT_FOUND,
      );
    }
  }

  @Post('login')
  async login(@Body('email') email: string, @Body('password') password: string) {
    if (!email || !password) {
      throw new HttpException(
        'Email and password are required',
        HttpStatus.BAD_REQUEST,
      );
    }
    try {
      const user = await this.usersService.validateUser(email, password);
      if (!user) {
        throw new HttpException('Invalid credentials', HttpStatus.UNAUTHORIZED);
      }
      return user;
    } catch (err) {
      throw new HttpException(
        {
          status: HttpStatus.UNAUTHORIZED,
          error: err.message || 'Unauthorized',
        },
        HttpStatus.UNAUTHORIZED,
      );
    }
  }
}
