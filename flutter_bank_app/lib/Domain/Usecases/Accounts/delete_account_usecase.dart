import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Repositories/accounts_repository.dart';

class DeleteAccountUsecase {
  final AccountsRepository repository;

  DeleteAccountUsecase(this.repository);

  Future<Either<Exception, void>> call(int id) async {
    return await repository.deleteAccount(id);
  }
}
