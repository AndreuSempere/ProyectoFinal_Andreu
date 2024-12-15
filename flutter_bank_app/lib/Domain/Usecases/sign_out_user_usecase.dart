import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';
import 'package:flutter_bank_app/core/usecase.dart';

class SignoutUserUseCase implements UseCase<void, NoParams> {
  final LoginRepository repository;
  SignoutUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.logout();
  }
}
