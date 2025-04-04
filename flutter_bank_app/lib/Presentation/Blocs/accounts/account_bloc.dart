import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/create_account_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/delete_account_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/get_accounts_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBloc extends Bloc<AccountsEvent, AccountState> {
  final CreateAccountUseCase createAccountUsecase;
  final GetAccountUseCase getAccountsUsecase;
  final DeleteAccountUsecase deleteAccountsUsecase;

  AccountBloc(
      {required this.createAccountUsecase,
      required this.getAccountsUsecase,
      required this.deleteAccountsUsecase})
      : super(const AccountState()) {
    on<GetAllAccount>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final result = await getAccountsUsecase(event.userId);
      result.fold(
        (error) {
          // If we already have accounts, keep them in the state
          final List<Account> accounts = state.accounts.isNotEmpty ? state.accounts : [];
          emit(state.copyWith(
            isLoading: false, 
            errorMessage: '', // Don't show the error message if we have accounts
            accounts: accounts
          ));
        },
        (accounts) {
          emit(state.copyWith(
            isLoading: false, 
            errorMessage: '', 
            accounts: accounts
          ));
        },
      );
    });

    on<CreateAccount>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await createAccountUsecase(event.account);
      result.fold(
        (error) {
          emit(state.copyWith(
            errorMessage: error.toString(),
            isLoading: false,
          ));
        },
        (account) {
          final updatedAccount = List<Account>.from(state.accounts)
            ..add(account);

          emit(state.copyWith(
            accounts: updatedAccount,
            isLoading: false,
          ));
          datosAccount(event.account.idUser);
        },
      );
    });

    on<DeleteAccountEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await deleteAccountsUsecase(event.id);
      result.fold(
        (error) {
          emit(state.copyWith(
            errorMessage: error.toString(),
            isLoading: false,
          ));
        },
        (_) {
          final updatedAccounts = state.accounts.where((account) {
            return account.idUser != event.id;
          }).toList();
          emit(state.copyWith(accounts: updatedAccounts));
          datosAccount(event.id);
        },
      );
    });
  }
  void datosAccount(id) {
    add(GetAllAccount(userId: id));
  }
}
