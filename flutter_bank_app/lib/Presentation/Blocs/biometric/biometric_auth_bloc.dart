import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuthBloc extends Bloc<BiometricAuthEvent, BiometricAuthState> {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  final LocalAuthentication localAuth;

  BiometricAuthBloc({
    required this.secureStorage,
    required this.sharedPreferences,
    required this.localAuth,
  }) : super(BiometricAuthInitial()) {
    on<LoadBiometricStatus>((event, emit) async {
      final isBiometricEnabled =
          sharedPreferences.getBool('is_biometric_enabled') ?? false;
      emit(BiometricStatusLoaded(isBiometricEnabled));
    });

    on<ActivateBiometricAuth>((event, emit) async {
      try {
        final email = await secureStorage.read(key: 'user_email');
        final password = await secureStorage.read(key: 'user_password');
        if (email != null && password != null) {
          await sharedPreferences.setBool('is_biometric_enabled', true);
          emit(BiometricAuthActivated());
        } else {
          emit(BiometricAuthError('No se encontraron credenciales guardadas.'));
        }
      } catch (e) {
        emit(BiometricAuthError(
            'Fallo al activar la autenticación biométrica.'));
      }
    });

    on<DeactivateBiometricAuth>((event, emit) async {
      try {
        await sharedPreferences.setBool('is_biometric_enabled', false);
        emit(BiometricAuthDeactivated());
      } catch (e) {
        emit(BiometricAuthError('Failed to disable biometric authentication'));
      }
    });

    on<RequestBiometricLogin>((event, emit) async {
      try {
        final isBiometricEnabled =
            sharedPreferences.getBool('is_biometric_enabled') ?? false;

        if (isBiometricEnabled) {
          final canCheckBiometrics = await localAuth.canCheckBiometrics;
          final isDeviceSupported = await localAuth.isDeviceSupported();

          if (canCheckBiometrics && isDeviceSupported) {
            final isAuthenticated = await localAuth.authenticate(
              localizedReason: 'Por favor, autentíquese para iniciar sesión.',
              options: const AuthenticationOptions(
                biometricOnly: true,
                stickyAuth: true,
              ),
            );

            if (isAuthenticated) {
              final email = await secureStorage.read(key: 'user_email');
              final password = await secureStorage.read(key: 'user_password');

              if (email != null && password != null) {
                emit(BiometricLoginSuccess(email: email, password: password));
              } else {
                emit(BiometricAuthError(
                    'No se encontraron credenciales para iniciar sesión.'));
              }
            } else {
              emit(BiometricAuthError('Autenticación fallida.'));
            }
          } else {
            emit(BiometricAuthError(
                'El dispositivo no admite autenticación biométrica.'));
          }
        } else {
          emit(BiometricAuthError(
              'La autenticación biométrica no está habilitada.'));
        }
      } catch (e) {
        emit(BiometricAuthError(
            'Fallo al intentar iniciar sesión con biometría.'));
      }
    });
  }
}
