import 'package:equatable/equatable.dart';

abstract class BiometricAuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BiometricAuthInitial extends BiometricAuthState {}

class BiometricStatusLoaded extends BiometricAuthState {
  final bool isEnabled;

  BiometricStatusLoaded(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class BiometricAuthActivated extends BiometricAuthState {}

class BiometricAuthDeactivated extends BiometricAuthState {}

class BiometricAuthError extends BiometricAuthState {
  final String message;

  BiometricAuthError(this.message);

  @override
  List<Object?> get props => [message];
}
