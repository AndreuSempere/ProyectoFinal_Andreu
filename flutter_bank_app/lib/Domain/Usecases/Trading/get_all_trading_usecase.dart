import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/trading_repository.dart';

class GetAllTradingUseCase {
  final TradingRepository repository;

  GetAllTradingUseCase(this.repository);

  Future<Either<String, List<TradingEntity>>> call() async {
    return await repository.getAllTrading();
  }
}
