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
  final int id;
  final Map<String, dynamic> filters;

  GetAllTransactions({required this.id, this.filters = const {}});

  @override
  List<Object?> get props => [id, filters];
}

class CreateTransactionsBizum extends TransactionsEvent {
  final Transaction transaction;

  CreateTransactionsBizum(
    this.transaction,
  );
}
