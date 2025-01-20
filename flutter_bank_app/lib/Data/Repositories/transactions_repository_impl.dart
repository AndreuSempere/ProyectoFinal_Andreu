import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Data/Datasources/transactions_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Models/transaction_model.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/transactions_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSource remoteDataSource;
  TransactionsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      final transactionModels = await remoteDataSource.getAllTransactions();
      return Right(transactionModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<String, Transaction>> createdTransaction(
      Transaction transaction) async {
    try {
      final transactionModel = TransactionModel(
        cantidad: transaction.cantidad,
        tipo: transaction.tipo,
        descripcion: transaction.descripcion,
        account: transaction.account,
        targetAccount: transaction.targetAccount,
      );

      await remoteDataSource.createdTransactions(transactionModel);
      final createdTransaction = Transaction(
        cantidad: transaction.cantidad,
        tipo: transaction.tipo,
        descripcion: transaction.descripcion,
        account: transaction.account,
        targetAccount: transaction.targetAccount,
      );

      return Right(createdTransaction);
    } catch (e) {
      return Left('Fallo al crear la transaction: $e');
    }
  }
}
