import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bank_app/Data/Datasources/accounts_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Datasources/firebase_auth_datasource.dart';
import 'package:flutter_bank_app/Data/Datasources/transactions_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Repositories/accounts_repository_impl.dart';
import 'package:flutter_bank_app/Data/Repositories/sign_in_repository_impl.dart';
import 'package:flutter_bank_app/Data/Repositories/transactions_repository_impl.dart';
import 'package:flutter_bank_app/Domain/Repositories/accounts_repository.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Domain/Repositories/transactions_repository.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/create_account_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/delete_account_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/get_accounts_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/fetch_user_data_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/new_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/reset_password_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_in_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_out_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_up_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/update_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Transactions/create_transaction_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Transactions/get_transactions_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/language/language_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // DataSource
  sl.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()));
  sl.registerLazySingleton<AccountRemoteDataSource>(
      () => AccountRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<TransactionsRemoteDataSource>(
      () => TransactionsRemoteDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<SignInRepository>(() => SignInRepositoryImpl(
      sl<FirebaseAuthDataSource>(), sl<SharedPreferences>()));
  sl.registerLazySingleton<AccountsRepository>(
      () => AccountRepositoryImpl(sl()));
  sl.registerLazySingleton<TransactionsRepository>(
      () => TransactionsRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton<SigninUserUseCase>(() => SigninUserUseCase(sl()));
  sl.registerLazySingleton<SignupUserUseCase>(() => SignupUserUseCase(sl()));
  sl.registerLazySingleton<SignoutUserUseCase>(() => SignoutUserUseCase(sl()));
  sl.registerLazySingleton<FetchUserDataUseCase>(
      () => FetchUserDataUseCase(sl()));
  sl.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton<NewUserUseCase>(() => NewUserUseCase(sl()));
  sl.registerLazySingleton<UpdateUserUsecase>(() => UpdateUserUsecase(sl()));

  sl.registerLazySingleton<GetAccountUseCase>(() => GetAccountUseCase(sl()));
  sl.registerLazySingleton<CreateAccountUseCase>(
      () => CreateAccountUseCase(sl()));
  sl.registerLazySingleton<DeleteAccountUsecase>(
      () => DeleteAccountUsecase(sl()));

  sl.registerLazySingleton<GetTransactionsUseCase>(
      () => GetTransactionsUseCase(sl()));

  sl.registerLazySingleton<CreateTransactionUseCase>(
      () => CreateTransactionUseCase(sl()));

  // Bloc
  sl.registerFactory<LoginBloc>(() => LoginBloc(
      signInRepository: sl<SignInRepository>(),
      signInUserUseCase: sl<SigninUserUseCase>(),
      signUpUserUseCase: sl<SignupUserUseCase>(),
      signOutUserUseCase: sl<SignoutUserUseCase>(),
      getCurrentUserUseCase: sl<FetchUserDataUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
      newUserUseCase: sl<NewUserUseCase>(),
      updateUserUseCase: sl<UpdateUserUsecase>()));

  sl.registerFactory<AccountBloc>(() => AccountBloc(
        createAccountUsecase: sl<CreateAccountUseCase>(),
        getAccountsUsecase: sl<GetAccountUseCase>(),
        deleteAccountsUsecase: sl<DeleteAccountUsecase>(),
      ));

  sl.registerFactory<TransactionBloc>(() => TransactionBloc(
        createTransactionUsecase: sl<CreateTransactionUseCase>(),
        getTransactionsUsecase: sl<GetTransactionsUseCase>(),
      ));

  sl.registerFactory<LanguageBloc>(() => LanguageBloc());
}
