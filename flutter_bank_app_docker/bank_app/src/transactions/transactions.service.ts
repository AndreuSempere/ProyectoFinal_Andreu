import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Accounts } from '../accounts/accounts.entity';
import { Transaction } from './transactions.entity';
import { CreateTransactionDto } from './transactions.dto';

@Injectable()
export class TransactionsService {
  constructor(
    @InjectRepository(Transaction)
    private readonly transactionsRepository: Repository<Transaction>,
    @InjectRepository(Accounts)
    private readonly accountsRepository: Repository<Accounts>,

  
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

  async createTransaction(
    createTransactionDto: CreateTransactionDto,
  ): Promise<{ message: string }> {
      const { accountId, targetAccountId, cantidad, tipo, descripcion } = createTransactionDto;
      const sourceAccount = await this.accountsRepository.findOne({
        where: { id_cuenta: accountId },
      });
    
      if (!sourceAccount) {
        throw new Error('Cuenta origen no encontrada');
      }
    
      if (tipo === 'ingreso') {
        sourceAccount.saldo += cantidad;
      } else if (tipo === 'gasto' && sourceAccount.saldo < cantidad) {
        throw new Error('Fondos insuficientes en la cuenta origen');
      } else if (tipo === 'gasto') {
        sourceAccount.saldo -= cantidad;
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
    
      await this.accountsRepository.save(sourceAccount);
      if (targetAccount) {
        await this.accountsRepository.save(targetAccount);
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
    
      if (!sourceAccount) {
        throw new Error('Cuenta origen no encontrada');
      }
    
      if (tipo === 'ingreso') {
        sourceAccount.saldo += cantidad;
      } else if (tipo === 'gasto' && sourceAccount.saldo < cantidad) {
        throw new Error('Fondos insuficientes en la cuenta origen');
      } else if (tipo === 'gasto') {
        sourceAccount.saldo -= cantidad;
      } else {
        throw new Error('Tipo de transacción inválido');
      }
    
      let targetAccount = null;
    
      if (targetAccountId) {
        targetAccount = await this.accountsRepository
          .createQueryBuilder('account')
          .innerJoinAndSelect('account.id_user', 'user')
          .where('user.telf = :telf', { telf: targetAccountId })
          .getOne();
    
        if (!targetAccount) {
          throw new Error('Cuenta destino no encontrada');
        }
    
        if (tipo === 'gasto') {
          targetAccount.saldo += cantidad;
        }
      }
    
      const sourceTransaction = this.transactionsRepository.create({
        account: { id_cuenta: sourceAccount.id_cuenta },
        cantidad,
        tipo: tipo === 'ingreso' ? 'ingreso' : 'gasto',
        descripcion: descripcion || 'Transferencia',
      });
    
      let targetTransaction = null;
    
      if (targetAccount) {
        targetTransaction = this.transactionsRepository.create({
          account: { id_cuenta: targetAccount.id_cuenta },
          cantidad,
          tipo: 'ingreso',
          descripcion: descripcion || 'Bizum recibido',
        });
      }
    
      await this.transactionsRepository.save(sourceTransaction);
      if (targetTransaction) {
        await this.transactionsRepository.save(targetTransaction);
      }
          await this.accountsRepository.save(sourceAccount);
      if (targetAccount) {
        await this.accountsRepository.save(targetAccount);
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