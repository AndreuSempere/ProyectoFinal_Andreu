import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Accounts } from '../accounts/accounts.entity';
import { Transaction } from './transactions.entity';
import { CreateTransactionDto } from './transactions.dto';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { FirebaseService } from '../firebase/firebase.service';
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
    private readonly httpService: HttpService,
    private readonly firebaseService: FirebaseService,
  ) {}

  // Obtener una transacción por su id
  async getTransaction(id?: number): Promise<any> {
    const result = await this.transactionsRepository.findOneBy({
      id_transaction: id,
    });

    return result;
  }

  // Obtener todas las transacciones
  async getTransactionAll(): Promise<any> {
    const result = await this.transactionsRepository.find({
      relations: ['account'],
    });

    return result;
  }

  // Obtener transacciones por id de cuenta
  async getTransactionsByAccountId(accountId: number): Promise<any> {
    const result = await this.transactionsRepository
      .createQueryBuilder('transaction')
      .innerJoinAndSelect('transaction.account', 'account')
      .where('account.id_cuenta = :accountId', { accountId })
      .orderBy('transaction.id_transaction', 'DESC')
      .getMany();

    return result;
  }

  //Crear una transacción ya sea por traspaso(sin TargetAccountId) o por transferencia(con TargetAccountId)
  async createTransaction(
    createTransactionDto: CreateTransactionDto,
  ): Promise<any> {
    try {
      const sourceAccount = await this.accountsRepository.findOne({
        where: { id_cuenta: createTransactionDto.accountId },
        relations: ['id_user'],
      });

      if (!sourceAccount) {
        throw new HttpException(
          'Cuenta de origen no encontrada',
          HttpStatus.BAD_REQUEST,
        );
      }

      let targetAccount = null;
      let targetUser = null;

      if (createTransactionDto.targetAccountId) {
        // Verificar si targetAccountId es un string (posiblemente un IBAN)
        const isIban = typeof createTransactionDto.targetAccountId === 'string' && 
                       createTransactionDto.targetAccountId.toString().startsWith('ES');
        
        if (isIban) {
          // Si es un IBAN, buscar por numero_cuenta
          targetAccount = await this.accountsRepository.findOne({
            where: { numero_cuenta: createTransactionDto.targetAccountId.toString() },
            relations: ['id_user'],
          });
        } else {
          // Si no es un IBAN, buscar por id_cuenta
          const targetId = typeof createTransactionDto.targetAccountId === 'string' 
            ? parseInt(createTransactionDto.targetAccountId, 10) 
            : createTransactionDto.targetAccountId;
            
          targetAccount = await this.accountsRepository.findOne({
            where: { id_cuenta: targetId },
            relations: ['id_user'],
          });
          
          // Si no se encuentra por id_cuenta, intentar buscar por numero_cuenta
          if (!targetAccount && typeof createTransactionDto.targetAccountId === 'string') {
            targetAccount = await this.accountsRepository.findOne({
              where: { numero_cuenta: createTransactionDto.targetAccountId },
              relations: ['id_user'],
            });
          }
        }
        
        targetUser = targetAccount;

        if (!targetAccount) {
          throw new HttpException(
            'Cuenta de destino no encontrada',
            HttpStatus.BAD_REQUEST,
          );
        }
        
        // Asegurarse de que siempre se envíe el ID numérico a Spring
        createTransactionDto.targetAccountId = targetAccount.id_cuenta;
      }

      // Llamar al servicio de Spring para procesar la transacción
      const response = await firstValueFrom(
        this.httpService.post(this.externalServiceUrl, createTransactionDto),
      );

      // Enviar notificación push si hay cuenta destino y token de Firebase
      if (
        targetAccount &&
        targetAccount.id_user &&
        targetAccount.id_user.firebaseToken
      ) {
        if (this.firebaseService) {
          try {
            await this.firebaseService.sendPushNotification(
              targetUser.id_user.firebaseToken,
              `Has recibido una transferencia`,
              `Te han enviado ${createTransactionDto.cantidad}€ por ${createTransactionDto.descripcion || 'Transferencia'}`,
            );
            console.log('Notificación enviada desde transaction:');
          } catch (error) {
            console.error('Error al enviar la notificación:', error);
          }
        }
      }

      // Generar PDF para la transacción
      const pdfJson = {
        cantidad: createTransactionDto.cantidad,
        tipo: 'Transferencia',
        descripcion: createTransactionDto.descripcion || 'Sin descripción',
        accountNumber: sourceAccount.numero_cuenta,
        targetAccountNumber: targetAccount?.numero_cuenta || null,
        userName: sourceAccount?.id_user?.name || null,
        userSurname: sourceAccount?.id_user?.surname || null,
        targetUserName: targetUser?.id_user?.name || null,
        targetUserSurname: targetUser?.id_user?.surname || null,
      };

      try {
        const pdfResponse = await firstValueFrom(
          this.httpService.post(`${this.odooServiceUrl}`, pdfJson, {
            responseType: 'arraybuffer',
          }),
        );
        console.log('Respuesta del servicio PDF recibida');

        if (
          pdfResponse &&
          pdfResponse.data &&
          pdfResponse.headers['content-type'] === 'application/pdf'
        ) {
          try {
            if (
              !this.firebaseService ||
              !this.firebaseService.isInitialized()
            ) {
              console.error(
                'Servicio de Firebase no disponible o no inicializado',
              );
            } else {
              const userId =
                sourceAccount?.id_user?.id_user?.toString() || 'unknown';
              const transactionId = Date.now().toString();

              if (
                !pdfResponse.data ||
                !Buffer.isBuffer(Buffer.from(pdfResponse.data))
              ) {
                console.error('Datos de PDF inválidos');
                throw new Error('Datos de PDF inválidos');
              }

              // Subir el PDF a Firebase Storage
              const pdfUrl = await this.firebaseService.uploadPdfToStorage(
                Buffer.from(pdfResponse.data),
                userId,
                transactionId,
              );

              console.log('PDF subido a Firebase Storage:', pdfUrl);

              try {
                const sourceTransactions =
                  await this.transactionsRepository.find({
                    where: {
                      account: { id_cuenta: createTransactionDto.accountId },
                      cantidad: createTransactionDto.cantidad,
                    },
                    order: { id_transaction: 'DESC' },
                    take: 1,
                  });

                if (sourceTransactions && sourceTransactions.length > 0) {
                  const sourceTransaction = sourceTransactions[0];
                  sourceTransaction.receipt_url = pdfUrl;
                  await this.transactionsRepository.save(sourceTransaction);
                  console.log(
                    'URL del PDF actualizada en la transacción de origen:',
                    sourceTransaction.id_transaction,
                  );
                }

                if (targetAccount) {
                  const targetTransactions =
                    await this.transactionsRepository.find({
                      where: {
                        account: { id_cuenta: targetAccount.id_cuenta },
                        cantidad: createTransactionDto.cantidad,
                      },
                      order: { id_transaction: 'DESC' },
                      take: 1,
                    });

                  if (targetTransactions && targetTransactions.length > 0) {
                    const targetTransaction = targetTransactions[0];
                    targetTransaction.receipt_url = pdfUrl;
                    await this.transactionsRepository.save(targetTransaction);
                    console.log(
                      'URL del PDF actualizada en la transacción de destino:',
                      targetTransaction.id_transaction,
                    );
                  }
                }
              } catch (dbError) {
                console.error(
                  'Error al actualizar las URLs de los recibos en las transacciones:',
                  dbError,
                );
              }
            }
          } catch (uploadError) {
            console.error(
              'Error al subir PDF a Firebase Storage:',
              uploadError,
            );
          }
        } else {
          console.error(
            'La respuesta no es un PDF válido:',
            pdfResponse.headers['content-type'],
          );
        }
      } catch (pdfError) {
        console.error('Error al enviar datos para PDF:', pdfError);
      }

      return response.data || { message: 'Transacción procesada con éxito' };
    } catch (error) {
      console.error('Error al procesar la transacción:', error);
      throw new HttpException(
        error.response?.data?.message || 'Error al procesar la transacción',
        error.response?.status || HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  // Crear una transacción por Bizum
  async bizumTransaction(
    createTransactionDto: CreateTransactionDto,
  ): Promise<{ message: string }> {
    const { accountId, targetAccountId, cantidad, tipo, descripcion } =
      createTransactionDto;

    const sourceAccount = await this.accountsRepository
      .createQueryBuilder('account')
      .innerJoinAndSelect('account.id_user', 'user')
      .where('user.telf = :telf', { telf: accountId })
      .getOne();

    if (!sourceAccount) throw new Error('Cuenta origen no encontrada');

    if (tipo === 'ingreso') {
      sourceAccount.saldo += cantidad;
    } else if (tipo === 'gasto') {
      if (sourceAccount.saldo < cantidad)
        throw new Error('Fondos insuficientes');
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
    if (targetTransaction)
      await this.transactionsRepository.save(targetTransaction);

    await this.accountsRepository.save(sourceAccount);
    if (cuenta_destino) await this.accountsRepository.save(cuenta_destino);

    if (cuenta_destino) {
      console.log('ID de la cuenta destino:', cuenta_destino.id_cuenta);
      const targetUser = await this.accountsRepository
        .createQueryBuilder('account')
        .innerJoinAndSelect('account.id_user', 'user')
        .where('account.id_cuenta = :id_cuenta', {
          id_cuenta: cuenta_destino.id_cuenta,
        })
        .getOne();

      console.log('Resultado de la consulta:', targetUser);
      console.log(
        'Firebase Token encontrado:',
        targetUser?.id_user?.firebaseToken,
      );

      if (targetUser?.id_user?.firebaseToken) {
        try {
          await this.firebaseService.sendPushNotification(
            targetUser.id_user.firebaseToken,
            `Has recibido un Bizum de ${sourceAccount.id_user.name}`,
            `Te han enviado ${cantidad}€ por ${descripcion}`,
          );
          console.log('Notificación enviada desde Bizum:');
        } catch (error) {
          throw new Error('Error al enviar la notificación:' + error);
        }
      }
    }

    return { message: 'Bizum procesado con éxito' };
  }

  // Eliminar una transacción por su id
  async deleteTransaction(id: number): Promise<{ message: string }> {
    const result = await this.transactionsRepository.delete(id);
    if (result.affected === 0) {
      throw new HttpException(
        'Transaction no encontrado',
        HttpStatus.NOT_FOUND,
      );
    }
    return { message: 'Transaction eliminado' };
  }
}
