import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';
import 'package:flutter_bank_app/core/failure.dart';

abstract class CreditCardRepository {
  Future<Either<Failure, List<CreditCardEntity>>> getAllCreditCards();
  Future<Either<Failure, CreditCardEntity>> getCreditCardById(int id);
  Future<Either<Failure, CreditCardEntity>> getCreditCardByNumber(int number);
  Future<Either<Failure, bool>> createCreditCard(CreditCardEntity card);
  Future<Either<Failure, bool>> updateCreditCard(int id, CreditCardEntity card);
  Future<Either<Failure, void>> deleteCreditCard(int id);
}
