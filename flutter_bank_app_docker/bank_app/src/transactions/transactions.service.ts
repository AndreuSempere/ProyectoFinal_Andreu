import { Injectable } from '@nestjs/common';
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
    // Encontrar la cuenta a partir del accountId
    const account = await this.accountsRepository.findOne({
      where: { id_cuenta: createTransactionDto.accountId },
    });
        
    if (!account) {
      throw new Error('Cuenta no encontrada');
    }

    // Obtenemos el saldo actual de la cuenta
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
      account: account, 
      cantidad: createTransactionDto.cantidad,
      tipo: createTransactionDto.tipo,
      descripcion: createTransactionDto.descripcion,
    });

    await this.transactionsRepository.save(transaction);
    account.saldo = newBalance;
    await this.accountsRepository.save(account);

    return { message: 'Transacción procesada con éxito' };
  }
}