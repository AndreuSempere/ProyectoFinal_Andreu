import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/core/failure.dart';

abstract class LoginRepository {
  Future<Either<Failure, void>> signIn(String email, String password);
  Future<Either<Failure, void>> signUp(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, void>> resetPassword(String email);
}