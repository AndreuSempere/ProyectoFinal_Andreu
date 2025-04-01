import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { User } from './users.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcryptjs';
import { CreateUserDto, UpdateUserDto } from './user.dto';
import { UtilsService } from '../utils/utils.service';
import { FirebaseService } from '../firebase/firebase.service';
@Injectable()
export class UsersService {
  constructor(
    private readonly utilsService: UtilsService,
    private firebaseService: FirebaseService,
    @InjectRepository(User) private readonly usersRepository: Repository<User>,
  ) {}

  // Crear un nuevo usuario pero encriptando la contraseña para insertarla en la base de datos
  async createUser(createUserDto: CreateUserDto): Promise<User> {
    const usuario = this.usersRepository.create(createUserDto);
    const passwordHash = await bcrypt.hash(createUserDto.password, 10);
    usuario.password = passwordHash;
    return this.usersRepository.save(usuario);
  }

  // Obtener los datos de un usuario por su id
  async getUser(id_user: number, xml?: string): Promise<User | string | null> {
    const user = await this.usersRepository.findOneBy({ id_user });

    if (user != null) {
      if (xml == 'true') {
        const jsonformatted = JSON.stringify(user);
        return this.utilsService.convertJSONtoXML(jsonformatted);
      } else {
        return user;
      }
    } else {
      throw new HttpException('Not found', HttpStatus.NOT_FOUND);
    }
  }

  // Actualizar los datos del usuario
  async updateUser(updateUserDto: UpdateUserDto): Promise<User> {
    const user = await this.usersRepository.findOne({
      where: { id_user: updateUserDto.id_user },
    });

    if (!user) {
      throw new Error('Usuario no encontrado');
    }

    const oldTelf = user.telf;
    const newTelf = updateUserDto.telf;
    const hasTelfChanged = newTelf && oldTelf !== newTelf;
    this.usersRepository.merge(user, updateUserDto);
    const updatedUser = await this.usersRepository.save(user);

    if (hasTelfChanged && user.firebaseToken) {
      try {
        await this.firebaseService.sendPushNotification(
          user.firebaseToken,
          'Has añadido tu número de telefono',
          `El numero añadido es ${newTelf}`,
        );
        console.log('Notificación enviada por cambio de teléfono.');
      } catch (error) {
        console.error('Error al enviar la notificación:', error);
      }
    }

    return updatedUser;
  }

  // Eliminar un usuario por su id
  async deleteUser(id_user: number): Promise<void> {
    await this.usersRepository.delete(id_user);
  }

  // Validar que el email y la contraseña son correctos
  async validateUser(email: string, password: string): Promise<User | null> {
    const user = await this.usersRepository.findOne({ where: { email } });
    if (user && (await bcrypt.compare(password, user.password))) {
      return user;
    }
    return null;
  }

  // Obtener un usuario por su email
  async getUserByEmail(email: string) {
    return this.usersRepository
      .createQueryBuilder('u')
      .where('u.email LIKE :email', { email })
      .getOne();
  }
}
