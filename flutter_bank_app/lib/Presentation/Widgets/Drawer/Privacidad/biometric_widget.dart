import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_state.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart'; // Importamos local_auth

class BiometricSettingsPage extends StatelessWidget {
  const BiometricSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              '${AppLocalizations.of(context)!.unexpectedError}: ${snapshot.error}',
            ),
          );
        } else if (snapshot.hasData) {
          final sharedPreferences = snapshot.data!;
          final secureStorage = FlutterSecureStorage();
          final localAuth = LocalAuthentication();

          return BlocProvider(
            create: (context) => BiometricAuthBloc(
              sharedPreferences: sharedPreferences,
              secureStorage: secureStorage,
              localAuth: localAuth, // Inyectamos local_auth aquí
            ),
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context)!.biometricSettingsTitle,
                ),
              ),
              body: BlocBuilder<BiometricAuthBloc, BiometricAuthState>(
                builder: (context, state) {
                  if (state is BiometricAuthInitial) {
                    context
                        .read<BiometricAuthBloc>()
                        .add(LoadBiometricStatus());
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BiometricStatusLoaded) {
                    return _buildBiometricSettings(
                      context: context,
                      isEnabled: state.isEnabled,
                    );
                  } else if (state is BiometricAuthError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.unexpectedState,
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
        return Center(
          child: Text(AppLocalizations.of(context)!.unexpectedError),
        );
      },
    );
  }

  Widget _buildBiometricSettings({
    required BuildContext context,
    required bool isEnabled,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isEnabled
                ? AppLocalizations.of(context)!.biometricEnabled
                : AppLocalizations.of(context)!.biometricDisabled,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildButton(
            context: context,
            label: isEnabled
                ? AppLocalizations.of(context)!.disableBiometric
                : AppLocalizations.of(context)!.enableBiometric,
            icon: Icons.fingerprint,
            onPressed: () {
              if (isEnabled) {
                context
                    .read<BiometricAuthBloc>()
                    .add(DeactivateBiometricAuth());
                Navigator.pop(context);
              } else {
                context.read<BiometricAuthBloc>().add(ActivateBiometricAuth());
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
