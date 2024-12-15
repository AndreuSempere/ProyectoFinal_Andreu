import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class SignupUserUseCase {
  final LoginRepository repository;

  SignupUserUseCase(this.repository);

  Future<Either<Failure, void>> call(String email, String password) async {
    return await repository.signUp(email, password);
  }
}
