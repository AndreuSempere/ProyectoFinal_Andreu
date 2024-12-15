import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Data/Datasources/firebase_auth_datasource.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class SignInRepositoryImpl implements LoginRepository {
  final FirebaseAuthDataSource dataSource;

  SignInRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> signIn(String email, String password) async {
    try {
      await dataSource.signIn(email, password);
      return const Right(null);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signUp(String email, String password) async {
    try {
      await dataSource.signUp(email, password);
      return const Right(null);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, String>> isLoggedIn() async {
    try {
      String? user = dataSource.getCurrentUser();
      return Right(user ?? "NO_USER");
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }
}
