import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';

class TradingState extends Equatable {
  final List<TradingEntity> tradings;
  final bool isLoading;
  final String errorMessage;
  final List<TradingEntity> tradingRecords;

  const TradingState({
    this.tradings = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.tradingRecords = const [],
  });

  TradingState copyWith({
    List<TradingEntity>? tradings,
    bool? isLoading,
    String? errorMessage,
    List<TradingEntity>? tradingRecords,
  }) {
    return TradingState(
      tradings: tradings ?? this.tradings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      tradingRecords: tradingRecords ?? this.tradingRecords,
    );
  }

  @override
  List<Object?> get props =>
      [tradings, isLoading, errorMessage, tradingRecords];
}
