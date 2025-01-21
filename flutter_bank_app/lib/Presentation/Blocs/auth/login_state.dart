import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/user_entity.dart';

class LoginState extends Equatable {
  final String? email;
  final bool isLoading;
  final bool isSuccess;
  final UserEntity? user;
  final String? message;

  const LoginState({
    this.email,
    required this.isLoading,
    required this.isSuccess,
    this.user,
    this.message,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? email,
    UserEntity? user,
    String? message,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      email: email ?? this.email,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  factory LoginState.initial() => const LoginState(
        isLoading: false,
        isSuccess: false,
      );

  factory LoginState.loading() => const LoginState(
        isLoading: true,
        isSuccess: false,
      );

  factory LoginState.success({
    String? email,
    UserEntity? user,
  }) =>
      LoginState(
        isLoading: false,
        isSuccess: true,
        email: email,
        user: user,
      );

  factory LoginState.failure(String errorMessage) => LoginState(
        isLoading: false,
        isSuccess: false,
        message: errorMessage,
      );

  @override
  List<Object?> get props => [email, isLoading, isSuccess, user, message];
}

class AuthError extends LoginState {
  final String errorMessage;

  const AuthError({
    required this.errorMessage,
  }) : super(
          isLoading: false,
          isSuccess: false,
          message: errorMessage,
        );

  @override
  List<Object?> get props => [errorMessage];
}
