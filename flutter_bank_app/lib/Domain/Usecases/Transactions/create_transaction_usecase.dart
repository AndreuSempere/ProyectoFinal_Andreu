import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/transactions_repository.dart';

class CreateTransactionUseCase {
  final TransactionsRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<Either<String, Transaction>> call(Transaction transaction) async {
    return await repository.createdTransaction(transaction);
  }
}
