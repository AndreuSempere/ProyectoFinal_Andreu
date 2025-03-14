import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/investment_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/investments_repository.dart';

class CreateInvestmentUseCase {
  final InvestmentsRepository repository;

  CreateInvestmentUseCase(this.repository);

  Future<Either<String, InvestmentEntity>> call(
      InvestmentEntity investments) async {
    return await repository.createdInvestments(investments);
  }
}
