import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_state.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricSettingsPage extends StatelessWidget {
  const BiometricSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final sharedPreferences = snapshot.data!;
          final secureStorage = FlutterSecureStorage();

          return BlocProvider(
            create: (context) => BiometricAuthBloc(
              sharedPreferences: sharedPreferences,
              secureStorage: secureStorage,
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('Biometric Settings')),
              body: BlocBuilder<BiometricAuthBloc, BiometricAuthState>(
                builder: (context, state) {
                  if (state is BiometricAuthInitial) {
                    BlocProvider.of<BiometricAuthBloc>(context)
                        .add(LoadBiometricStatus());
                    return Center(child: CircularProgressIndicator());
                  } else if (state is BiometricStatusLoaded) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.isEnabled
                                ? 'Biometric Authentication is enabled'
                                : 'Biometric Authentication is disabled',
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            label: state.isEnabled
                                ? 'Disable Biometric'
                                : 'Enable Biometric',
                            icon: Icons.fingerprint,
                            onPressed: () {
                              if (state.isEnabled) {
                                context
                                    .read<BiometricAuthBloc>()
                                    .add(DeactivateBiometricAuth());
                              } else {
                                context
                                    .read<BiometricAuthBloc>()
                                    .add(ActivateBiometricAuth());
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (state is BiometricAuthError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text('Unexpected State'));
                  }
                },
              ),
            ),
          );
        }
        return Center(child: Text('Unexpected Error'));
      },
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
    );
  }
}
