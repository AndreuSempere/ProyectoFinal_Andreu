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
  final SignInRepository signInRepository;
  final SigninUserUseCase signInUserUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final SignupUserUseCase signUpUserUseCase;
  final FetchUserDataUseCase getCurrentUserUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final NewUserUseCase newUserUseCase;
  final UpdateUserUsecase updateUserUseCase;

  LoginBloc({
    required this.signInRepository,
    required this.signInUserUseCase,
    required this.signOutUserUseCase,
    required this.signUpUserUseCase,
    required this.getCurrentUserUseCase,
    required this.resetPasswordUseCase,
    required this.newUserUseCase,
    required this.updateUserUseCase,
  }) : super(LoginState.initial()) {
    _mapEventsToState();
  }

  void _mapEventsToState() {
    on<LoginButtonPressed>(_Login);
    on<RegisterButtonPressed>(_Register);
    on<NewUserEvent>(_NewUser);
    on<FetchUserDataEvent>(_FetchUserData);
    on<LogoutButtonPressed>(_Logout);
    on<ResetPasswordEvent>(_ResetPassword);
    on<UpdateUserEvent>(_UpdateUser);
  }

  Future<void> _Login(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginState.loading());

    final result = await signInUserUseCase(event.email, event.password);
    if (result.isRight()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', event.email);
    }

    result.fold(
      (failure) => emit(LoginState.failure("Fallo al realizar el login")),
      (user) => emit(LoginState.success(email: event.email)),
    );
  }

  Future<void> _Register(
      RegisterButtonPressed event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await signUpUserUseCase(event.email, event.password);

    result.fold(
      (failure) => emit(state.copyWith(
          isSuccess: false,
          isLoading: false,
          message: "Usuario ya existe, por favor ingresa otro email")),
      (_) => emit(state.copyWith(
          isSuccess: true,
          isLoading: false,
          message: "Usuario registrado con éxito")),
    );
  }

  Future<void> _NewUser(NewUserEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await newUserUseCase(event.name, event.surname, event.email,
        event.password, event.dni, event.age);

    result.fold(
      (errorMessage) => emit(state.copyWith(
          isSuccess: false,
          isLoading: false,
          message: "Usuario ya existe, por favor ingresa otro email")),
      (_) => emit(state.copyWith(
          isSuccess: true,
          isLoading: false,
          message: "Usuario registrado con éxito")),
    );
  }

  Future<void> _FetchUserData(
      FetchUserDataEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? 'unknown_user@example.com';

      final result = await getCurrentUserUseCase(email);

      result.fold(
        (failure) =>
            emit(LoginState.failure("Fallo al obtener los datos del usuario")),
        (user) => emit(state.copyWith(isLoading: false, user: user)),
      );
    } catch (e) {
      emit(LoginState.failure(
          'Error al acceder a las preferencias compartidas.'));
    }
  }

  Future<void> _Logout(
      LogoutButtonPressed event, Emitter<LoginState> emit) async {
    final result = await signOutUserUseCase(NoParams());
    result.fold(
      (failure) => emit(LoginState.failure("Fallo al realizar el logout")),
      (_) => emit(LoginState.initial()),
    );
  }

  Future<void> _ResetPassword(
      ResetPasswordEvent event, Emitter<LoginState> emit) async {
    final result = await resetPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(
          LoginState.failure('Error al enviar correo de restablecimiento')),
      (_) => emit(LoginState.initial()),
    );
  }

  Future<void> _UpdateUser(
      UpdateUserEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await updateUserUseCase(event.idUser, event.name,
        event.surname, event.email, event.dni, event.age);

    result.fold(
      (errorMessage) => emit(state.copyWith(
          isLoading: false, message: errorMessage, isSuccess: false)),
      (_) {
        emit(state.copyWith(
            isLoading: false, isSuccess: true, message: "Usuario actualizado"));
        add(FetchUserDataEvent());
      },
    );
  }
}
