import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/investment_entity.dart';
import 'package:flutter_bank_app/core/failure.dart';

abstract class InvestmentsRepository {
  Future<Either<Failure, List<InvestmentEntity>>> getInvestments(int accountid);
  Future<Either<String, void>> createdInvestments(
      String symbol, double amount, int accountId);
}
