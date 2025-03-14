import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Data/Datasources/investments_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Models/investments_model.dart';
import 'package:flutter_bank_app/Domain/Entities/investment_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/investments_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

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
  Future<Either<String, InvestmentEntity>> createdInvestments(
      InvestmentEntity investments) async {
    try {
      final investmentsModel = InvestmentModel(
        idInvestment: investments.idInvestment,
        idAccount: investments.idAccount,
        amount: investments.amount,
        purchase_price: investments.purchase_price,
        current_value: investments.current_value,
        tradingId: investments.tradingId,
        purchase_date: investments.purchase_date,
        last_updated: investments.last_updated,
      );

      await remoteDataSource.createdInvestment(investmentsModel);
      final createdInvestment = InvestmentEntity(
        idInvestment: investments.idInvestment,
        idAccount: investments.idAccount,
        amount: investments.amount,
        purchase_price: investments.purchase_price,
        current_value: investments.current_value,
        tradingId: investments.tradingId,
        purchase_date: investments.purchase_date,
        last_updated: investments.last_updated,
      );

      return Right(createdInvestment);
    } catch (e) {
      return Left('Fallo al crear la cuenta: $e');
    }
  }
}
