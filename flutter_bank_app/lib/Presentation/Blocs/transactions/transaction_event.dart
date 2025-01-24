import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';

// Eventos
abstract class TransactionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateTransactions extends TransactionsEvent {
  final Transaction transaction;

  CreateTransactions(
    this.transaction,
  );
}

class GetAllTransactions extends TransactionsEvent {
  final Map<String, dynamic> filters;

  GetAllTransactions([this.filters = const {}]);

  @override
  List<Object?> get props => [filters];
}

class CreateTransactionsBizum extends TransactionsEvent {
  final Transaction transaction;

  CreateTransactionsBizum(
    this.transaction,
  );
}
