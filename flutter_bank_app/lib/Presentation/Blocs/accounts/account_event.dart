import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';

// Eventos
abstract class AccountsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateAccount extends AccountsEvent {
  final Account account;

  CreateAccount(
    this.account,
  );
}

class GetAllAccount extends AccountsEvent {
  final int id;
  GetAllAccount({required this.id});
}

class DeleteAccountEvent extends AccountsEvent {
  final int id;
  DeleteAccountEvent({required this.id});
}
