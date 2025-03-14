import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/investment_entity.dart';

class InvestmentsState extends Equatable {
  final List<InvestmentEntity> investments;
  final bool isLoading;
  final String errorMessage;

  const InvestmentsState({
    this.investments = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  InvestmentsState copyWith({
    List<InvestmentEntity>? investments,
    bool? isLoading,
    String? errorMessage,
  }) {
    return InvestmentsState(
      investments: investments ?? this.investments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [investments, isLoading, errorMessage];
}
