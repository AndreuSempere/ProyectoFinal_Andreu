import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Repositories/investments_repository.dart';

class CreateInvestmentUseCase {
  final InvestmentsRepository repository;

  CreateInvestmentUseCase(this.repository);

  Future<Either<String, void>> call(
      String symbol, double amount, int accountId) async {
    return await repository.createdInvestments(symbol, amount, accountId);
  }
}
