import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bank_app/Data/Datasources/firebase_auth_datasource.dart';
import 'package:flutter_bank_app/Data/Repositories/sign_in_repository_impl.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Domain/Usecases/get_current_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/reset_password_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/sign_in_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/sign_out_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/sign_up_user_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void configureDependencies() {
  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // FirebaseAuthDataSource
  sl.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(
      () => SignInRepositoryImpl(sl<FirebaseAuthDataSource>()));

  // Casos de uso
  sl.registerLazySingleton<SigninUserUseCase>(() => SigninUserUseCase(sl()));
  sl.registerLazySingleton<SignupUserUseCase>(() => SignupUserUseCase(sl()));
  sl.registerLazySingleton<SignoutUserUseCase>(() => SignoutUserUseCase(sl()));
  sl.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(sl()));

  // Bloc
  sl.registerFactory<LoginBloc>(() => LoginBloc(
      loginRepository: sl<LoginRepository>(),
      signInUserUseCase: sl<SigninUserUseCase>(),
      signUpUserUseCase: sl<SignupUserUseCase>(),
      signOutUserUseCase: sl<SignoutUserUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>()));
}
