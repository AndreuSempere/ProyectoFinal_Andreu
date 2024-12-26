import 'package:equatable/equatable.dart';
import 'package:flutter_bank_app/Domain/Entities/user_entity.dart';

class LoginState extends Equatable {
  final String? email;
  final bool isLoading;
  final UserEntity? user;
  final String? errorMessage;

  const LoginState({
    this.isLoading = false,
    this.email,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    String? email,
    UserEntity? user,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory LoginState.initial() => const LoginState();

  factory LoginState.loading() => const LoginState(isLoading: true);

  factory LoginState.success(String email) => LoginState(email: email);

  factory LoginState.failure(String errorMessage) =>
      LoginState(errorMessage: errorMessage);

  @override
  List<Object?> get props => [user, isLoading, errorMessage];
}

class AuthError extends LoginState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
