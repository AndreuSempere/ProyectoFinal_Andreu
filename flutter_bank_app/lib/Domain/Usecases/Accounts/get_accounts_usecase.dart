import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/accounts_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class GetAccountUseCase {
  final AccountsRepository repository;

  GetAccountUseCase(this.repository);

  Future<Either<Failure, List<Account>>> call(int id) async {
    return await repository.getAccounts(id);
  }
}
