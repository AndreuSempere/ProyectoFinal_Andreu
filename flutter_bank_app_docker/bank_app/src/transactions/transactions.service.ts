import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Accounts } from '../accounts/accounts.entity';
import { Transaction } from './transactions.entity';
import { CreateTransactionDto } from './transactions.dto';
import { FirebaseService } from '../firebase/firebase.service';

@Injectable()
export class TransactionsService {
  constructor(
    @InjectRepository(Transaction)
    private readonly transactionsRepository: Repository<Transaction>,
    @InjectRepository(Accounts)
    private readonly accountsRepository: Repository<Accounts>,
    private firebaseService: FirebaseService,
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
      const { accountId, targetAccountId, cantidad, tipo, descripcion } = createTransactionDto;
      const origen_Account = await this.accountsRepository.findOne({
        where: { id_cuenta: accountId },
      });
    
      if (!origen_Account) {
        throw new Error('Cuenta origen no encontrada');
      }
    
      if (tipo === 'ingreso') {
        origen_Account.saldo += cantidad;
      } else if (tipo === 'gasto' && origen_Account.saldo < cantidad) {
        throw new Error('Fondos insuficientes en la cuenta origen');
      } else if (tipo === 'gasto') {
        origen_Account.saldo -= cantidad;
      } else {
        throw new Error('Tipo de transacción inválido');
      }
    
      let targetAccount = null;
      if (targetAccountId) {
        targetAccount = await this.accountsRepository.findOne({
          where: { id_cuenta: targetAccountId },
        });
    
        if (!targetAccount) {
          throw new Error('Cuenta destino no encontrada');
        }
    
        if (tipo === 'gasto') {
          targetAccount.saldo += cantidad;
        }
      }
    
      const sourceTransaction = this.transactionsRepository.create({
        account: { id_cuenta: accountId },
        cantidad,
        tipo: tipo === 'ingreso' ? 'ingreso' : 'gasto',
        descripcion: descripcion || 'Transferencia',
      });
    
      let targetTransaction = null;
      if (targetAccount) {
        targetTransaction = this.transactionsRepository.create({
          account: { id_cuenta: targetAccountId },
          cantidad,
          tipo: 'ingreso',
          descripcion: descripcion || 'Transferencia recibida',
        });
      }
    
      await this.transactionsRepository.save(sourceTransaction);
      if (targetTransaction) {
        await this.transactionsRepository.save(targetTransaction);
      }
    
      await this.accountsRepository.save(origen_Account);
      if (targetAccount) {
        await this.accountsRepository.save(targetAccount);
      }

    if (targetAccount) {
      console.log("ID de la cuenta destino:", targetAccount.id_cuenta);
      
      const targetUser = await this.accountsRepository
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
            `Te han enviado ${cantidad}€ por ${descripcion || 'Transferencia'}`
          );
          console.log("Notificación enviada desde transaction:");
        } catch (error) {
          console.error("Error al enviar la notificación:", error);
        }
      }
    }
      return { message: 'Transacción procesada con éxito' };
    }

    async bizumTransaction(
      createTransactionDto: CreateTransactionDto,
    ): Promise<{ message: string }> {
      const { accountId, targetAccountId, cantidad, tipo, descripcion } = createTransactionDto;
    
      const sourceAccount = await this.accountsRepository
        .createQueryBuilder('account')
        .innerJoinAndSelect('account.id_user', 'user')
        .where('user.telf = :telf', { telf: accountId })
        .getOne();
    
      if (!sourceAccount) throw new Error('Cuenta origen no encontrada');
    
      if (tipo === 'ingreso') {
        sourceAccount.saldo += cantidad;
      } else if (tipo === 'gasto') {
        if (sourceAccount.saldo < cantidad) throw new Error('Fondos insuficientes');
        sourceAccount.saldo -= cantidad;
      } else {
        throw new Error('Tipo de transacción inválido');
      }
    
      let cuenta_destino = null;
      if (targetAccountId) {
        cuenta_destino = await this.accountsRepository
          .createQueryBuilder('account')
          .innerJoinAndSelect('account.id_user', 'user')
          .where('user.telf = :telf', { telf: targetAccountId })
          .getOne();
    
        if (!cuenta_destino) throw new Error('Cuenta destino no encontrada');
    
        if (tipo === 'gasto') cuenta_destino.saldo += cantidad;
      }
    
      const sourceTransaction = this.transactionsRepository.create({
        account: { id_cuenta: sourceAccount.id_cuenta },
        cantidad,
        tipo: tipo === 'ingreso' ? 'ingreso' : 'gasto',
        descripcion: descripcion || 'Transferencia',
      });
    
      let targetTransaction = null;
      if (cuenta_destino) {
        targetTransaction = this.transactionsRepository.create({
          account: { id_cuenta: cuenta_destino.id_cuenta },
          cantidad,
          tipo: 'ingreso',
          descripcion: descripcion || 'Bizum recibido',
        });
      }
    
      await this.transactionsRepository.save(sourceTransaction);
      if (targetTransaction) await this.transactionsRepository.save(targetTransaction);
    
      await this.accountsRepository.save(sourceAccount);
      if (cuenta_destino) await this.accountsRepository.save(cuenta_destino);
    
      if (cuenta_destino) {

        console.log("ID de la cuenta destino:", cuenta_destino.id_cuenta);
        const targetUser = await this.accountsRepository
          .createQueryBuilder('account')
          .innerJoinAndSelect('account.id_user', 'user')  
          .where('account.id_cuenta = :id_cuenta', { id_cuenta: cuenta_destino.id_cuenta })
          .getOne();

        console.log("Resultado de la consulta:", targetUser);
        console.log("Firebase Token encontrado:", targetUser?.id_user?.firebaseToken);

        if (targetUser?.id_user?.firebaseToken) {
          try {
            await this.firebaseService.sendPushNotification(
              targetUser.id_user.firebaseToken,
              `Has recibido un Bizum de ${sourceAccount.id_user.name}`,
              `Te han enviado ${cantidad}€ por ${descripcion}`
            );
            console.log("Notificación enviada desde Bizum:");
          } catch (error) {
            throw new Error('Error al enviar la notificación:');
          }
        }
      }
    
      return { message: 'Bizum procesado con éxito' };
    }
    
    async deleteTransaction(id: number): Promise<{ message: string }> {
      const result = await this.transactionsRepository.delete(id);
      if (result.affected === 0) {
        throw new HttpException('Transaction no encontrado', HttpStatus.NOT_FOUND);
      }
      return { message: 'Transaction eliminado' };
    }
}