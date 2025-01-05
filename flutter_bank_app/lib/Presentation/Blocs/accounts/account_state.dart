import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';

class AccountState extends Equatable {
  final List<Account> accounts;
  final bool isLoading;
  final String errorMessage;

  const AccountState({
    this.accounts = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  AccountState copyWith({
    List<Account>? accounts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AccountState(
      accounts: accounts ?? this.accounts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [accounts, isLoading, errorMessage];
}
