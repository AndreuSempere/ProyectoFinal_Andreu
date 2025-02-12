import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/credit_card_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class GetAllCreditCardsUseCase {
  final CreditCardRepository repository;

  GetAllCreditCardsUseCase(this.repository);

  Future<Either<Failure, List<CreditCardEntity>>> call() async {
    return await repository.getAllCreditCards();
  }
}
