abstract class BiometricAuthState {}

class BiometricAuthInitial extends BiometricAuthState {}

class BiometricStatusLoaded extends BiometricAuthState {
  final bool isEnabled;

  BiometricStatusLoaded(this.isEnabled);
}

class BiometricAuthActivated extends BiometricAuthState {}

class BiometricAuthDeactivated extends BiometricAuthState {}

class BiometricAuthError extends BiometricAuthState {
  final String message;

  BiometricAuthError(this.message);
}

class BiometricLoginSuccess extends BiometricAuthState {
  final String email;
  final String password;

  BiometricLoginSuccess({required this.email, required this.password});
}
