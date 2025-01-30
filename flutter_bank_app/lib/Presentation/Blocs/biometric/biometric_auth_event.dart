abstract class BiometricAuthEvent {}

class LoadBiometricStatus extends BiometricAuthEvent {}

class ActivateBiometricAuth extends BiometricAuthEvent {}

class DeactivateBiometricAuth extends BiometricAuthEvent {}

class RequestBiometricLogin extends BiometricAuthEvent {}

class LogoutBiometricAuth extends BiometricAuthEvent {}
