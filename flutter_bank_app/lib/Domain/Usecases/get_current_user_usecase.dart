import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';
import 'package:flutter_bank_app/core/usecase.dart';

class GetCurrentUserUseCase extends UseCase<String?, NoParams> {
  final LoginRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return repository.isLoggedIn();
  }
}
