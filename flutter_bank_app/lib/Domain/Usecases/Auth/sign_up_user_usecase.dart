import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';

class SignupUserUseCase {
  final SignInRepository repository;

  SignupUserUseCase(this.repository);

  Future<Either<String, void>> call(String name, String surname, String email,
      String password, String dni, String age) async {
    return await repository.signUp(name, surname, email, password, dni, age);
  }
}
