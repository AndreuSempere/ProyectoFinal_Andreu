import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Domain/Usecases/get_current_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/reset_password_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/sign_in_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/sign_out_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/sign_up_user_usecase.dart';
import 'package:flutter_bank_app/core/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  final SigninUserUseCase signInUserUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final SignupUserUseCase signUpUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  LoginBloc(
      {required this.loginRepository,
      required this.signInUserUseCase,
      required this.signOutUserUseCase,
      required this.signUpUserUseCase,
      required this.getCurrentUserUseCase,
      required this.resetPasswordUseCase})
      : super(LoginState.initial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginState.loading());
      final result = await signInUserUseCase(event.email, event.password);
      result.fold(
        (failure) => emit(LoginState.failure("Fallo al realizar el login")),
        (user) => emit(LoginState.success(event.email)),
      );
    });

    on<RegisterButtonPressed>((event, emit) async {
      final result = await signUpUserUseCase(event.email, event.password);
      result.fold(
          (failure) =>
              emit(LoginState.failure("Fallo al registrar al usuario")),
          (user) => emit(LoginState.success(event.email)));
    });

    on<CheckAuthentication>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(LoginState.failure("Fallo al verificar la autenticación")),
        (username) => emit(LoginState.success(username!)),
      );
    });

    on<LogoutButtonPressed>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
          (failure) => emit(LoginState.failure("Fallo al realizar el logout")),
          (_) => emit(LoginState.initial()));
    });

    on<ResetPasswordEvent>((event, emit) async {
      final result = await resetPasswordUseCase(event.email);
      result.fold(
          (failure) => emit(
              LoginState.failure('Error al enviar correo de restablecimiento')),
          (_) => emit(LoginState.initial()));
    });
  }
}
