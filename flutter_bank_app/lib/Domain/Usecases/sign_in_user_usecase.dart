import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class SigninUserUseCase {
  final LoginRepository repository;

  SigninUserUseCase(this.repository);

  Future<Either<Failure, void>> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}
