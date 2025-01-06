import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/user_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';
import 'package:flutter_bank_app/core/usecase.dart';

class FetchUserDataUseCase extends UseCase<UserEntity, String> {
  final SignInRepository repository;

  FetchUserDataUseCase(this.repository);

  @override
  // ignore: avoid_renaming_method_parameters
  Future<Either<Failure, UserEntity>> call(String email) async {
    return repository.getUserInfo(email);
  }
}
