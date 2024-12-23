class LoginState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;

  const LoginState({
    this.isLoading = false,
    this.email,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    String? email,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory LoginState.initial() => const LoginState();

  factory LoginState.loading() => const LoginState(isLoading: true);

  factory LoginState.success(String email) => LoginState(email: email);

  factory LoginState.failure(String errorMessage) =>
      LoginState(errorMessage: errorMessage);

  // @override
  // List<Object?> get props => [isLoading, email, errorMessage];
}

class AuthError extends LoginState {
  final String message;

  AuthError({required this.message});

  List<Object?> get props => [message];
}
