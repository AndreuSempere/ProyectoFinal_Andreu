import 'package:dartz/dartz.dart';
import 'package:flutter_bank_app/Data/Datasources/trading_remote_datasource.dart';
import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';
import 'package:flutter_bank_app/Domain/Repositories/trading_repository.dart';

class TradingRepositoryImpl implements TradingRepository {
  final TradingRemoteDataSource remoteDataSource;
  TradingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<TradingEntity>>> getAllTrading() async {
    try {
      final tradingModels = await remoteDataSource.getAllTrading();
      return Right(tradingModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left('Fallo al obtener los datos de trading: $e');
    }
  }

  @override
  Future<Either<String, List<TradingEntity>>> getTradingRecord(
      String name) async {
    try {
      final tradingModels = await remoteDataSource.getTradingRecord(name);
      return Right(tradingModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left('Fallo al obtener los datos de valor Trading: $e');
    }
  }
}
