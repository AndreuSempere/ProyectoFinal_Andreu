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
      emit(state.copyWith(isLoading: true, accounts: []));

      final result = await getAccountsUsecase();
      result.fold(
        (error) => emit(state.copyWith(
            isLoading: false, errorMessage: error.toString(), accounts: [])),
        (accounts) {
          emit(state.copyWith(isLoading: false, accounts: accounts));
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
          datosAccount();
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
          datosAccount();
        },
      );
    });
  }
  void datosAccount() {
    add(GetAllAccount());
  }
}
