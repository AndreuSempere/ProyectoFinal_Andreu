import 'package:equatable/equatable.dart';

// Eventos
abstract class InvestmentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateInvestment extends InvestmentsEvent {
  final String symbol;
  final double amount;
  final int accountId;

  CreateInvestment({
    required this.symbol,
    required this.amount,
    required this.accountId,
  });
}

class GetAllInvestments extends InvestmentsEvent {
  final int accountid;

  GetAllInvestments({required this.accountid});
}
