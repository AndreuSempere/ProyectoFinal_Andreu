import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';

class CreditCardState extends Equatable {
  final List<CreditCardEntity> creditCards;
  final bool isLoading;
  final String errorMessage;

  const CreditCardState({
    this.creditCards = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  CreditCardState copyWith({
    List<CreditCardEntity>? creditCards,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CreditCardState(
      creditCards: creditCards ?? this.creditCards,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [creditCards, isLoading, errorMessage];
}
