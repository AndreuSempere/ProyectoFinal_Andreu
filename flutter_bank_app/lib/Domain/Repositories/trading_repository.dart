import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';

abstract class TradingRepository {
  Future<Either<String, List<TradingEntity>>> getAllTrading();
}
