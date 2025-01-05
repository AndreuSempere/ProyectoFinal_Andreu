import 'package:flutter_bank_app/Domain/Repositories/sign_in_repository.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/fetch_user_data_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/new_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/reset_password_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_in_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_out_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/sign_up_user_usecase.dart';
import 'package:flutter_bank_app/Domain/Usecases/Auth/update_user_usecase.dart';

import 'package:flutter_bank_app/core/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  final SigninUserUseCase signInUserUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final SignupUserUseCase signUpUserUseCase;
  final FetchUserDataUseCase getCurrentUserUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final NewUserUseCase newuserUseCase;
  final UpdateUserUsecase updateuserUseCase;

  LoginBloc(
      {required this.loginRepository,
      required this.signInUserUseCase,
      required this.signOutUserUseCase,
      required this.signUpUserUseCase,
      required this.getCurrentUserUseCase,
      required this.resetPasswordUseCase,
      required this.newuserUseCase,
      required this.updateuserUseCase})
      : super(LoginState.initial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginState.loading());
      final result = await signInUserUseCase(event.email, event.password);
      if (result.isRight()) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', event.email);
      }
      result.fold(
        (failure) => emit(LoginState.failure("Fallo al realizar el login")),
        (user) => emit(LoginState.success(event.email)),
      );
    });

    on<RegisterButtonPressed>((event, emit) async {
      final result = await signUpUserUseCase(event.email, event.password);
      result.fold(
          (failure) => emit(LoginState.failure(
              "Usuario ya existe, por favor ingresa otro email")),
          (user) => emit(LoginState.success(event.email)));
    });

    on<FetchUserDataEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final prefs = await SharedPreferences.getInstance();
        final email =
            prefs.getString('user_email') ?? 'unknown_user@example.com';

        final result = await getCurrentUserUseCase(email);
        result.fold(
            (failure) => emit(
                LoginState.failure("Fallo al obtener los datos del usuario")),
            (user) => emit(state.copyWith(isLoading: false, user: user)));
      } catch (e) {
        emit(LoginState.failure(
            'Error al acceder a las preferencias compartidas.'));
      }
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

    on<NewUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final result = await newuserUseCase(event.name, event.surname,
            event.email, event.password, event.dni, event.age);

        result.fold(
          (errorMessage) {
            emit(state.copyWith(
              isLoading: false,
              errorMessage: errorMessage,
            ));
          },
          (_) {
            emit(state.copyWith(
              isLoading: false,
            ));
          },
        );
      } catch (error) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Error al crear el usuario: $error',
        ));
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final result = await updateuserUseCase(
            event.name, event.surname, event.email, event.dni, event.age);

        result.fold(
          (errorMessage) {
            emit(state.copyWith(
              isLoading: false,
              errorMessage: errorMessage,
            ));
          },
          (_) {
            emit(state.copyWith(
              isLoading: false,
            ));
          },
        );
      } catch (error) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Error al actualizar el usuario: $error',
        ));
      }
    });
  }
}
