import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Repositories/credit_card_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class DeleteCreditCardUseCase {
  final CreditCardRepository repository;

  DeleteCreditCardUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteCreditCard(id);
  }
}
