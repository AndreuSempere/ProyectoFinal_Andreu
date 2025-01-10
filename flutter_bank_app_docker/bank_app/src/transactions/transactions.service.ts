import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Accounts } from '../accounts/accounts.entity';
import { Transaction } from './transactions.entity';
import { CreateTransactionDto } from './transactions.dto';
import { AccountsService } from '../accounts/accounts.service';

@Injectable()
export class TransactionsService {
  constructor(
    @InjectRepository(Transaction)
    private readonly transactionsRepository: Repository<Transaction>,
    @InjectRepository(Accounts)
    private readonly accountsRepository: Repository<Accounts>,
    private readonly accountsService: AccountsService,

  
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
    const account = await this.accountsRepository.findOne({
      where: { id_cuenta: createTransactionDto.accountId },
    });
  
    if (!account) {
      throw new Error('Cuenta no encontrada');
    }
  
    let newBalance = account.saldo;
  
    if (createTransactionDto.tipo === 'ingreso') {
      newBalance += createTransactionDto.cantidad;
    } else if (createTransactionDto.tipo === 'gasto') {
      if (newBalance < createTransactionDto.cantidad) {
        throw new Error('Fondos insuficientes');
      }
      newBalance -= createTransactionDto.cantidad;
    } else {
      throw new Error('Tipo de transacción inválido');
    }
  
    const transaction = this.transactionsRepository.create({
      ...createTransactionDto,
      account: { id_cuenta: createTransactionDto.accountId },
    });
  
    await this.transactionsRepository.save(transaction);
    await this.accountsService.updateAccount(account.id_cuenta, { saldo: newBalance });
    return { message: 'Transacción procesada con éxito' };
  }
  
    async deleteTransaction(id: number): Promise<{ message: string }> {
      const result = await this.transactionsRepository.delete(id);
      if (result.affected === 0) {
        throw new HttpException('Transaction no encontrado', HttpStatus.NOT_FOUND);
      }
      return { message: 'Transaction eliminado' };
    }
}