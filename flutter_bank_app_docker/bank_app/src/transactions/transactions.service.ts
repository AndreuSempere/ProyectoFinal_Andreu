import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Accounts } from '../accounts/accounts.entity';
import { Transaction } from './transactions.entity';
import { CreateTransactionDto } from './transactions.dto';
import { FirebaseService } from '../firebase/firebase.service';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { config } from 'dotenv';
config();

@Injectable()
export class TransactionsService {
  private readonly externalServiceUrl = process.env.PRIVATE_KEY_SPRING;
  private readonly odooServiceUrl = process.env.PRIVATE_KEY_ODOO;
  constructor(
    @InjectRepository(Transaction)
    private readonly transactionsRepository: Repository<Transaction>,
    @InjectRepository(Accounts)
    private readonly accountsRepository: Repository<Accounts>,
    private firebaseService: FirebaseService,
    private readonly httpService: HttpService,
  ) {}

  async getTransaction(id?: number): Promise<any> {
    const result = await this.transactionsRepository.findOneBy({
      id_transaction: id,
    });

    return result;
  }

  async getTransactionAll(): Promise<any> {
    const result = await this.transactionsRepository.find({
      relations: ['account'],
    });
 
    return result;
  }

  async getTransactionsByAccountId(accountId: number): Promise<any> {
    const result = await this.transactionsRepository
      .createQueryBuilder('transaction')
      .innerJoinAndSelect('transaction.account', 'account')
      .where('account.id_cuenta = :accountId', { accountId })
      .getMany();
  
    return result;
  }

  async createTransaction(
    createTransactionDto: CreateTransactionDto,
  ): Promise<{ message: string }> {
    try {
      const sourceAccount = await this.accountsRepository.findOne({
        where: { id_cuenta: createTransactionDto.accountId },
      });
      
      if (!sourceAccount) {
        throw new HttpException('Cuenta origen no encontrada', HttpStatus.NOT_FOUND);
      }
      
      const springTransactionDto = {
        ...createTransactionDto,
        accountId: sourceAccount.id_cuenta,
      };
      
      let targetAccount = null;
      
      if (createTransactionDto.targetAccountId) {
        targetAccount = await this.accountsRepository.findOne({
          where: [
            { id_cuenta: createTransactionDto.targetAccountId }, 
            { numero_cuenta: createTransactionDto.targetAccountId }
          ],        
        });
        
        if (!targetAccount) {
          throw new HttpException('Cuenta destino no encontrada', HttpStatus.NOT_FOUND);
        }
        
        springTransactionDto.targetAccountId = targetAccount.id_cuenta;
      }
      
      const response = await firstValueFrom(
        this.httpService.post(`${this.externalServiceUrl}`, springTransactionDto)
      );
      
      let targetUser = null;
      
      if (createTransactionDto.targetAccountId && targetAccount) {
        console.log("ID de la cuenta destino:", targetAccount.id_cuenta);
        
        targetUser = await this.accountsRepository
          .createQueryBuilder('account')
          .innerJoinAndSelect('account.id_user', 'user')  
          .where('account.id_cuenta = :id_cuenta', { id_cuenta: targetAccount.id_cuenta })
          .getOne();
  
        console.log("Resultado de la consulta:", targetUser);
        console.log("Firebase Token encontrado:", targetUser?.id_user?.firebaseToken);
  
        if (targetUser?.id_user?.firebaseToken) {
          try {
            await this.firebaseService.sendPushNotification(
              targetUser.id_user.firebaseToken,
              `Has recibido una transferencia`,
              `Te han enviado ${createTransactionDto.cantidad}€ por ${createTransactionDto.descripcion || 'Transferencia'}`
            );
            console.log("Notificación enviada desde transaction:");
          } catch (error) {
            console.error("Error al enviar la notificación:", error);
          }
        }
      }
      
      // Crear JSON para enviar a otro endpoint
      const pdfJson = {
        cantidad: createTransactionDto.cantidad,
        tipo: "Transferencia",
        descripcion: createTransactionDto.descripcion || "Sin descripción",
        accountNumber: sourceAccount.numero_cuenta,
        targetAccountNumber: targetAccount?.numero_cuenta || null,
        userName: sourceAccount?.id_user?.name || null,
        userSurname: sourceAccount?.id_user?.surname || null,
        targetUserName: targetUser?.id_user?.name || null,
        targetUserSurname: targetUser?.id_user?.surname || null,
      };
      
      try {
        const pdfResponse = await firstValueFrom(
          this.httpService.post(`${this.odooServiceUrl}`, pdfJson)
        );
        console.log("Respuesta del servicio PDF:", pdfResponse.data);
      } catch (pdfError) {
        console.error("Error al enviar datos para PDF:", pdfError);
      }
      
      return response.data || { message: 'Transacción procesada con éxito' };
    } catch (error) {
      console.error('Error al procesar la transacción:', error);
      throw new HttpException(
        error.response?.data?.message || 'Error al procesar la transacción',
        error.response?.status || HttpStatus.INTERNAL_SERVER_ERROR
      );
    }
  }

  async bizumTransaction(
    createTransactionDto: CreateTransactionDto,
  ): Promise<{ message: string }> {
    try {
      // Enviar el DTO al servicio externo
      const response = await firstValueFrom(
        this.httpService.post(`${this.externalServiceUrl}/transaction/bizum`, createTransactionDto)
      );
      
      // Buscar información de la cuenta destino para notificaciones
      if (createTransactionDto.targetAccountId) {
        const cuenta_destino = await this.accountsRepository
          .createQueryBuilder('account')
          .innerJoinAndSelect('account.id_user', 'user')
          .where('user.telf = :telf', { telf: createTransactionDto.targetAccountId })
          .getOne();
        
        if (cuenta_destino) {
          const targetUser = await this.accountsRepository
            .createQueryBuilder('account')
            .innerJoinAndSelect('account.id_user', 'user')  
            .where('account.id_cuenta = :id_cuenta', { id_cuenta: cuenta_destino.id_cuenta })
            .getOne();
    
          if (targetUser?.id_user?.firebaseToken) {
            try {
              await this.firebaseService.sendPushNotification(
                targetUser.id_user.firebaseToken,
                `Has recibido un Bizum`,
                `Te han enviado ${createTransactionDto.cantidad}€ por ${createTransactionDto.descripcion || 'Bizum'}`
              );
              console.log("Notificación Bizum enviada:");
            } catch (error) {
              console.error("Error al enviar la notificación Bizum:", error);
            }
          }
        }
      }
      
      return response.data || { message: 'Bizum procesado con éxito' };
    } catch (error) {
      console.error('Error al procesar el Bizum:', error);
      throw new HttpException(
        error.response?.data?.message || 'Error al procesar el Bizum',
        error.response?.status || HttpStatus.INTERNAL_SERVER_ERROR
      );
    }
  }

  async deleteTransaction(id: number): Promise<{ message: string }> {
      const result = await this.transactionsRepository.delete(id);
      if (result.affected === 0) {
        throw new HttpException('Transaction no encontrado', HttpStatus.NOT_FOUND);
    }
      return { message: 'Transaction eliminado' };  }
}