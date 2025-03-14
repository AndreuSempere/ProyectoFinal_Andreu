import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/investment_entity.dart';

// Eventos
abstract class InvestmentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateInvestment extends InvestmentsEvent {
  final InvestmentEntity investment;

  CreateInvestment(
    this.investment,
  );
}

class GetAllInvestments extends InvestmentsEvent {
  final int accountid;

  GetAllInvestments({required this.accountid});
}
