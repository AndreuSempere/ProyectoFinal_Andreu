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
  Future<Either<Failure, List<Account>>> getAccounts() async {
    try {
      final accountModels = await remoteDataSource.getAllAccounts();
      return Right(accountModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(AuthFailure());
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
        fecCreacion: account.createdAt,
        accounts_type: account.accountType,
        id_user: account.idUser,
      );

      await remoteDataSource.createdAccount(accountModel);
      final createdAccount = Account(
        idCuenta: account.idCuenta,
        numeroCuenta: account.numeroCuenta,
        saldo: account.saldo,
        estado: account.estado,
        createdAt: account.createdAt,
        accountType: account.accountType,
        idUser: account.idUser,
      );

      return Right(createdAccount);
    } catch (e) {
      return Left('Fallo al crear el tweet: $e');
    }
  }
}
