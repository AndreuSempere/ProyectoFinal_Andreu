import 'package:equatable/equatable.dart';

abstract class BiometricAuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBiometricStatus extends BiometricAuthEvent {}

class ActivateBiometricAuth extends BiometricAuthEvent {
  ActivateBiometricAuth();
}

class DeactivateBiometricAuth extends BiometricAuthEvent {}
