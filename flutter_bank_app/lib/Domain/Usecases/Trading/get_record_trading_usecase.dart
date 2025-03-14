import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/trading_repository.dart';

class GetRecordTradingUseCase {
  final TradingRepository repository;

  GetRecordTradingUseCase(this.repository);

  Future<Either<String, List<TradingEntity>>> call(String name) async {
    return await repository.getTradingRecord(name);
  }
}
