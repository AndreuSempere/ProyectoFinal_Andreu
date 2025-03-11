import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';

abstract class TransactionsRepository {
  Future<Either<String, List<Transaction>>> getTransactions(int id);
  Future<Either<String, Transaction>> createdTransaction(
      Transaction transaction);
  Future<Either<String, Transaction>> createdTransactionsBizum(
      Transaction transaction);
}
