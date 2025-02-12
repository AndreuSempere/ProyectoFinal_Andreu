import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/credit_card_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class CreateCreditCardUseCase {
  final CreditCardRepository repository;

  CreateCreditCardUseCase(this.repository);

  Future<Either<Failure, bool>> call(CreditCardEntity card) async {
    return await repository.createCreditCard(card);
  }
}
