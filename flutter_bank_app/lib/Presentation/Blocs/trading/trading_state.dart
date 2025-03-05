import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';

class TradingState extends Equatable {
  final List<TradingEntity> tradings;
  final bool isLoading;
  final String errorMessage;

  const TradingState({
    this.tradings = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  TradingState copyWith({
    List<TradingEntity>? tradings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TradingState(
      tradings: tradings ?? this.tradings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [tradings, isLoading, errorMessage];
}
