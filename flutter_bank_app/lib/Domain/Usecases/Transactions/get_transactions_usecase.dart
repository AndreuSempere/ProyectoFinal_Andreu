import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/transactions_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class GetTransactionsUseCase {
  final TransactionsRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, List<Transaction>>> call(int id) async {
    return await repository.getTransactions(id);
  }
}
