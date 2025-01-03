import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bank_app/Data/Datasources/firebase_auth_datasource.dart';
import 'package:flutter_bank_app/Data/Repositories/sign_in_repository_impl.dart';
import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/fetch_user_data_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/new_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/reset_password_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_in_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_out_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_up_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/update_user_usecase.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //  FirebaseAuthDataSource
  sl.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()));

  //  Repository
  sl.registerLazySingleton<LoginRepository>(() => SignInRepositoryImpl(
      sl<FirebaseAuthDataSource>(), sl<SharedPreferences>()));

  // Casos de uso
  sl.registerLazySingleton<SigninUserUseCase>(() => SigninUserUseCase(sl()));
  sl.registerLazySingleton<SignupUserUseCase>(() => SignupUserUseCase(sl()));
  sl.registerLazySingleton<SignoutUserUseCase>(() => SignoutUserUseCase(sl()));
  sl.registerLazySingleton<FetchUserDataUseCase>(
      () => FetchUserDataUseCase(sl()));
  sl.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton<NewUserUseCase>(() => NewUserUseCase(sl()));
  sl.registerLazySingleton<UpdateUserUsecase>(() => UpdateUserUsecase(sl()));

  // Bloc
  sl.registerFactory<LoginBloc>(() => LoginBloc(
      loginRepository: sl<LoginRepository>(),
      signInUserUseCase: sl<SigninUserUseCase>(),
      signUpUserUseCase: sl<SignupUserUseCase>(),
      signOutUserUseCase: sl<SignoutUserUseCase>(),
      getCurrentUserUseCase: sl<FetchUserDataUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
      newuserUseCase: sl<NewUserUseCase>(),
      updateuserUseCase: sl<UpdateUserUsecase>()));
}
