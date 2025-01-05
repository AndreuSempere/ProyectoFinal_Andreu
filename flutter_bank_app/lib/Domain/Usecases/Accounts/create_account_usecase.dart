import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/accounts_repository.dart';

class CreateAccountUseCase {
  final AccountsRepository repository;

  CreateAccountUseCase(this.repository);

  Future<Either<String, Account>> call(Account account) async {
    return await repository.createdAccount(account);
  }
}
