import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/user_entity.dart';
import 'package:flutter_bank_app/core/failure.dart';

abstract class SignInRepository {
  Future<Either<Failure, void>> signIn(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, UserEntity>> getUserInfo(String email);
  Future<Either<String, void>> signUp(String name, String surname, String email,
      String password, String dni, String age);
  Future<Either<String, void>> updateUser(
      int idUser, String name, String surname, String email, int telf);
}
