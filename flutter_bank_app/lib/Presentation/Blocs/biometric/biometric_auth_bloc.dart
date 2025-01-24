import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuthBloc extends Bloc<BiometricAuthEvent, BiometricAuthState> {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  BiometricAuthBloc(
      {required this.secureStorage, required this.sharedPreferences})
      : super(BiometricAuthInitial()) {
    on<LoadBiometricStatus>((event, emit) async {
      final isBiometricEnabled =
          sharedPreferences.getBool('is_biometric_enabled') ?? false;
      emit(BiometricStatusLoaded(isBiometricEnabled));
    });

    on<ActivateBiometricAuth>((event, emit) async {
      try {
        final email = sharedPreferences.getString('user_email');
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
  }
}
