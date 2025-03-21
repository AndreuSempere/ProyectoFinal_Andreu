import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Data/Datasources/accounts_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Models/account_model.dart';
import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/accounts_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class AccountRepositoryImpl implements AccountsRepository {
  final AccountRemoteDataSource remoteDataSource;
  AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Account>>> getAccounts(int id) async {
    try {
      final accountModels = await remoteDataSource.getAccounts(id);
      return Right(accountModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(AuthFailure(
          message: 'Error al obtener las cuentas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<String, Account>> createdAccount(Account account) async {
    try {
      final accountModel = AccountModel(
        idCuenta: account.idCuenta,
        numero_cuenta: account.numeroCuenta,
        saldo: account.saldo,
        estado: account.estado,
        accounts_type: account.accountType,
        id_user: account.idUser,
        description: account.description,
        icon: account.icon,
      );

      await remoteDataSource.createdAccount(accountModel);
      final createdAccount = Account(
        idCuenta: account.idCuenta,
        numeroCuenta: account.numeroCuenta,
        saldo: account.saldo,
        estado: account.estado,
        accountType: account.accountType,
        idUser: account.idUser,
        description: account.description,
        icon: account.icon,
      );

      return Right(createdAccount);
    } catch (e) {
      return Left('Fallo al crear la cuenta: $e');
    }
  }

  @override
  Future<Either<Exception, void>> deleteAccount(int id) async {
    try {
      await remoteDataSource.deleteAccount(id);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Error al borrar la account'));
    }
  }
}
