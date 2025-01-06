import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';

class UpdateUserUsecase {
  final SignInRepository repository;

  UpdateUserUsecase(this.repository);

  Future<Either<String, void>> call(
      String name, String surname, String email, String dni, String age) async {
    return await repository.updateUser(name, surname, email, dni, age);
  }
}
