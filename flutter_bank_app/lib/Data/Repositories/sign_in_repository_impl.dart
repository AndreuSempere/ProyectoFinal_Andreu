import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Data/Datasources/firebase_auth_datasource.dart';
import 'package:flutter_bank_app/Domain/Entities/user_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInRepositoryImpl implements SignInRepository {
  final FirebaseAuthDataSource dataSource;
  final SharedPreferences sharedPreferences;

  SignInRepositoryImpl(this.dataSource, this.sharedPreferences);

  static const String _userKey = 'user_email';

  @override
  Future<Either<Failure, void>> signIn(String email, String password) async {
    try {
      await dataSource.signIn(email, password);
      await sharedPreferences.setString(_userKey, email);

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
      await sharedPreferences.setString(_userKey, email);

      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, String>> isLoggedIn() async {
    try {
      String? user = sharedPreferences.getString(_userKey);

      return Right(user ?? "NO_USER");
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      await sharedPreferences.remove(_userKey);

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

  @override
  Future<Either<String, void>> newUser(String name, String surname,
      String email, String password, String dni, String age) async {
    try {
      await dataSource.newUser(name, surname, email, password, dni, age);
      return const Right(null);
    } catch (e) {
      return Left('Fallo al crear el tweet: $e');
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo(String email) async {
    try {
      final userModel = await dataSource.getUserInfo(email);
      final userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<String, void>> updateUser(int idUser, String name,
      String surname, String email, String dni, String age) async {
    try {
      await dataSource.updateUser(idUser, name, surname, email, dni, age);
      return const Right(null);
    } catch (e) {
      return Left('Fallo al crear el tweet: $e');
    }
  }
}
