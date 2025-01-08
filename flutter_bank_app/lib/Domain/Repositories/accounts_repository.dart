import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:flutter_bank_app/core/failure.dart';

abstract class AccountsRepository {
  Future<Either<Failure, List<Account>>> getAccounts();
  Future<Either<String, Account>> createdAccount(Account account);
  Future<Either<Exception, void>> deleteAccount(int id);
}
