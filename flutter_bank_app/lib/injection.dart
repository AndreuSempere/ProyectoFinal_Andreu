import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bank_app/Data/Datasources/accounts_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Datasources/credit_card_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Datasources/firebase_auth_datasource.dart';
import 'package:flutter_bank_app/Data/Datasources/investments_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Datasources/trading_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Datasources/transactions_remote_datasource.dart';
import 'package:flutter_bank_app/Data/Repositories/accounts_repository_impl.dart';
import 'package:flutter_bank_app/Data/Repositories/credit_card_repository_impl.dart';
import 'package:flutter_bank_app/Data/Repositories/investments_repository_impl.dart';
import 'package:flutter_bank_app/Data/Repositories/sign_in_repository_impl.dart';
import 'package:flutter_bank_app/Data/Repositories/trading_repository_impl.dart';
import 'package:flutter_bank_app/Data/Repositories/transactions_repository_impl.dart';
import 'package:flutter_bank_app/Domain/Repositories/accounts_repository.dart';
import 'package:flutter_bank_app/Domain/Repositories/credit_card_repository.dart';
import 'package:flutter_bank_app/Domain/Repositories/investments_repository.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Domain/Repositories/trading_repository.dart';
import 'package:flutter_bank_app/Domain/Repositories/transactions_repository.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/create_account_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/delete_account_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Accounts/get_accounts_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/fetch_user_data_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_up_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/reset_password_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_in_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_out_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/update_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Credit%20Card/create_creditCard_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Credit%20Card/delete_creditCard_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Credit%20Card/get_all_creditCard_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Investments/create_investments_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Investments/get_all_investments_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Trading/get_all_trading_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Trading/get_record_trading_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Transactions/create_bizum_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Transactions/create_transaction_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Transactions/get_transactions_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/language/language_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  LocalAuthentication localAuth = LocalAuthentication();
  sl.registerLazySingleton<LocalAuthentication>(() => localAuth);

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
  sl.registerLazySingleton<CreditCardRemoteDataSource>(
      () => CreditCardRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<TradingRemoteDataSource>(
      () => TradingRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<InvestmentRemoteDataSource>(
      () => InvestmentsRemoteDatasourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<SignInRepository>(() => SignInRepositoryImpl(
      sl<FirebaseAuthDataSource>(),
      sl<SharedPreferences>(),
      sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<AccountsRepository>(
      () => AccountRepositoryImpl(sl()));
  sl.registerLazySingleton<TransactionsRepository>(
      () => TransactionsRepositoryImpl(sl()));
  sl.registerLazySingleton<CreditCardRepository>(
      () => CreditCardRepositoryImpl(sl()));
  sl.registerLazySingleton<TradingRepository>(
      () => TradingRepositoryImpl(sl()));
  sl.registerLazySingleton<InvestmentsRepository>(
      () => InvestmentsRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton<SigninUserUseCase>(() => SigninUserUseCase(sl()));
  sl.registerLazySingleton<SignupUserUseCase>(() => SignupUserUseCase(sl()));
  sl.registerLazySingleton<SignoutUserUseCase>(() => SignoutUserUseCase(sl()));
  sl.registerLazySingleton<FetchUserDataUseCase>(
      () => FetchUserDataUseCase(sl()));
  sl.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(sl()));
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
  sl.registerLazySingleton<CreateTransactionBizumUseCase>(
      () => CreateTransactionBizumUseCase(sl()));

  sl.registerLazySingleton<GetAllCreditCardsUseCase>(
      () => GetAllCreditCardsUseCase(sl()));
  sl.registerLazySingleton<CreateCreditCardUseCase>(
      () => CreateCreditCardUseCase(sl()));
  sl.registerLazySingleton<DeleteCreditCardUseCase>(
      () => DeleteCreditCardUseCase(sl()));

  sl.registerLazySingleton(() => GetAllTradingUseCase(sl()));
  sl.registerLazySingleton(() => GetRecordTradingUseCase(sl()));

  sl.registerLazySingleton(() => GetInvestmentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateInvestmentUseCase(sl()));

  // Bloc
  sl.registerFactory<LoginBloc>(() => LoginBloc(
      signInUserUseCase: sl<SigninUserUseCase>(),
      signUpUserUseCase: sl<SignupUserUseCase>(),
      signOutUserUseCase: sl<SignoutUserUseCase>(),
      getCurrentUserUseCase: sl<FetchUserDataUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
      updateUserUseCase: sl<UpdateUserUsecase>()));

  sl.registerFactory<AccountBloc>(() => AccountBloc(
        createAccountUsecase: sl<CreateAccountUseCase>(),
        getAccountsUsecase: sl<GetAccountUseCase>(),
        deleteAccountsUsecase: sl<DeleteAccountUsecase>(),
      ));

  sl.registerFactory<TransactionBloc>(() => TransactionBloc(
        createTransactionUsecase: sl<CreateTransactionUseCase>(),
        getTransactionsUsecase: sl<GetTransactionsUseCase>(),
        createTransactionBizumUsecase: sl<CreateTransactionBizumUseCase>(),
      ));

  sl.registerFactory<LanguageBloc>(() => LanguageBloc());

  sl.registerFactory<BiometricAuthBloc>(() => BiometricAuthBloc(
        sharedPreferences: sl<SharedPreferences>(),
        secureStorage: sl<FlutterSecureStorage>(),
        localAuth: sl<LocalAuthentication>(),
      ));

  sl.registerFactory<CreditCardBloc>(() => CreditCardBloc(
        createCreditCardUseCase: sl<CreateCreditCardUseCase>(),
        getAllCreditCardsUseCase: sl<GetAllCreditCardsUseCase>(),
        deleteCreditCardUseCase: sl<DeleteCreditCardUseCase>(),
      ));
  sl.registerFactory<TradingBloc>(() => TradingBloc(
        getTradingUsecase: sl<GetAllTradingUseCase>(),
        getRecordTradingUsecase: sl<GetRecordTradingUseCase>(),
      ));
  sl.registerFactory<InvestmentsBloc>(() => InvestmentsBloc(
        getInvestmentsUseCase: sl<GetInvestmentsUseCase>(),
        createInvestmentUseCase: sl<CreateInvestmentUseCase>(),
      ));
}
