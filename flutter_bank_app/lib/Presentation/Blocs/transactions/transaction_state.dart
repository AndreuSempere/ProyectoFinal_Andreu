import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';

class TransactionState extends Equatable {
  final List<Transaction> transactions;
  final bool isLoading;
  final String errorMessage;
  final String filter;

  const TransactionState({
    this.transactions = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.filter = '',
  });

  TransactionState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? errorMessage,
    String? filter,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [transactions, isLoading, errorMessage, filter];
}
