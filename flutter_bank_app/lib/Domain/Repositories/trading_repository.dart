import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';
import 'package:flutter_bank_app/core/failure.dart';

abstract class TradingRepository {
  Future<Either<String, List<TradingEntity>>> getAllTrading();
}
