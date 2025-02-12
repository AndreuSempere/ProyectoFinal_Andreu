import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/credit_card_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class GetCreditCardByNumberUseCase {
  final CreditCardRepository repository;

  GetCreditCardByNumberUseCase(this.repository);

  Future<Either<Failure, CreditCardEntity>> call(int number) async {
    return await repository.getCreditCardByNumber(number);
  }
}
