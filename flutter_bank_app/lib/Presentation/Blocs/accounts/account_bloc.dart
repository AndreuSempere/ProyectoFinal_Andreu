import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/create_account_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/get_accounts_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBloc extends Bloc<AccountsEvent, AccountState> {
  final CreateAccountUseCase createAccountUsecase;
  final GetAccountUseCase getAccountsUsecase;

  AccountBloc(
      {required this.createAccountUsecase, required this.getAccountsUsecase})
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
        },
      );
    });
  }
}
