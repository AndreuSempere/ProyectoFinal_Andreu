import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Data/Datasources/firebase_auth_datasource.dart';
import 'package:flutter_bank_app/Domain/Entities/user_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Services/notification_service.dart';
import 'package:flutter_bank_app/core/failure.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bank_app/core/unit.dart';

class SignInRepositoryImpl implements SignInRepository {
  final FirebaseAuthDataSource dataSource;
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  SignInRepositoryImpl(
      this.dataSource, this.sharedPreferences, this.secureStorage);

  static const String _userKey = 'user_email';
  @override
  Future<Either<Failure, Msg>> signIn(String email, String password) async {
    try {
      await dataSource.signIn(email, password);
      await sharedPreferences.setString(_userKey, email);

      try {
        await secureStorage.write(key: 'user_password', value: password);
        await secureStorage.write(key: 'user_email', value: email);
        print('Password guardada correctamente.');
      } catch (e) {
        print('Error al guardar la contraseña: $e');
      }

      final userInfoResult = await getUserInfo(email);
      return await userInfoResult.fold(
        (failure) {
          print("Error obteniendo usuario");
          return Left(failure);
        },
        (user) async {
          final tokenResult = await updateUserToken(user.idUser!);
          return tokenResult.fold(
            (errorMsg) => Left(AuthFailure()),
            (success) => Right(success),
          );
        },
      );
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<String, Msg>> signUp(String name, String surname, String email,
      String password, String dni, String age) async {
    try {
      final response = await dataSource.registerInBackend(
          name, surname, email, password, dni, age);

      if (!response) {
        return Left('Error al registrar la cuenta.');
      }

      await dataSource.signUp(email, password);
      await sharedPreferences.setString(_userKey, email);

      return const Right(Msg());
    } catch (e) {
      return Left('Fallo al crear la cuenta: $e');
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
  Future<Either<Failure, Msg>> logout() async {
    try {
      await dataSource.logout();
      await sharedPreferences.remove(_userKey);

      return const Right(Msg());
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, Msg>> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
      return const Right(Msg());
    } catch (e) {
      return Left(AuthFailure());
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
  Future<Either<String, Msg>> updateUser(
      int idUser, String name, String surname, String email, int telf) async {
    try {
      await dataSource.updateUser(idUser, name, surname, email, telf);
      return const Right(Msg());
    } catch (e) {
      return Left('Fallo al actualizar la cuenta: $e');
    }
  }

  Future<Either<String, Msg>> updateUserToken(int idUser) async {
    try {
      final fetchedToken = await NotificationService().getToken();
      final savedToken = sharedPreferences.getString('firebase_token');

      if (savedToken == fetchedToken) {
        print("El token ya está actualizado. No es necesario enviarlo.");
        return const Right(Msg());
      }
      await sharedPreferences.setString('firebase_token', fetchedToken!);
      await dataSource.updateUserToken(idUser, fetchedToken);
      return const Right(Msg());
    } catch (e) {
      return Left('Fallo al añadir el token a la cuenta: $e');
    }
  }
}
