import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Data/Datasources/credit_card_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Models/credit_card_model.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/credit_card_repository.dart';
import 'package:flutter_bank_app/core/failure.dart';

class CreditCardRepositoryImpl implements CreditCardRepository {
  final CreditCardRemoteDataSource remoteDataSource;
  CreditCardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CreditCardEntity>>> getAllCreditCards() async {
    try {
      final cardModels = await remoteDataSource.getAllCreditCards();
      return Right(cardModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CreditCardEntity>> getCreditCardById(int id) async {
    try {
      final cardModel = await remoteDataSource.getCreditCardById(id);
      return Right(cardModel.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CreditCardEntity>> getCreditCardByNumber(
      int number) async {
    try {
      final cardModel = await remoteDataSource.getCreditCardByNumber(number);
      return Right(cardModel.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createCreditCard(CreditCardEntity card) async {
    try {
      final cardModel = CardModel(
          id_tarjeta: card.id_tarjeta,
          cardHolderName: card.cardHolderName,
          numero_tarjeta: card.numero_tarjeta,
          tipo_tarjeta: card.tipo_tarjeta,
          fecha_expiracion: card.fecha_expiracion,
          cvv: card.cardCvv,
          color: card.cardColor,
          id_cuenta: card.id_cuenta);

      final result = await remoteDataSource.createCreditCard(cardModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateCreditCard(
      int id, CreditCardEntity card) async {
    try {
      final cardModel = CardModel(
          cardHolderName: card.cardHolderName,
          numero_tarjeta: card.numero_tarjeta,
          tipo_tarjeta: card.tipo_tarjeta,
          fecha_expiracion: card.fecha_expiracion,
          cvv: card.cardCvv,
          color: card.cardColor,
          id_cuenta: card.id_cuenta);

      final result = await remoteDataSource.updateCreditCard(id, cardModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCreditCard(int id) async {
    try {
      await remoteDataSource.deleteCreditCard(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
