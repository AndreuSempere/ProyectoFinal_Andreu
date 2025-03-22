import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Data/Datasources/investments_remote_datasource.dart';
import 'package:flutter_bank_app/Domain/Entities/investment_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/investments_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';
import 'package:flutter_bank_app/core/unit.dart';

class InvestmentsRepositoryImpl implements InvestmentsRepository {
  final InvestmentRemoteDataSource remoteDataSource;
  InvestmentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<InvestmentEntity>>> getInvestments(
      int accountid) async {
    try {
      final investmentsModels =
          await remoteDataSource.getInvestments(accountid);
      return Right(investmentsModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<String, Msg>> createdInvestments(
      String symbol, double amount, int accountId) async {
    try {
      await remoteDataSource.createdInvestment(symbol, amount, accountId);
      return const Right(Msg());
    } catch (e) {
      return Left('Fallo al crear la inversión: $e');
    }
  }
}
