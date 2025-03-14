import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/investment_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/investments_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class GetInvestmentsUseCase {
  final InvestmentsRepository repository;

  GetInvestmentsUseCase(this.repository);

  Future<Either<Failure, List<InvestmentEntity>>> call(int accountid) async {
    return await repository.getInvestments(accountid);
  }
}
