import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/biometric/biometric_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      context.read<LoginBloc>().add(
            LoginButtonPressed(email: email, password: password),
          );
    }
  }

  Future<void> signInWithBiometrics(BuildContext context) async {
    context.read<BiometricAuthBloc>().add(RequestBiometricLogin());
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    context.read<LoginBloc>().stream.listen((state) {
      if (state.email != null) {
        context.push('/home');
      } else if (state.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.message ??
                  AppLocalizations.of(context)!.errorRegistrarUsuario)),
        );
      }
    });

    context.read<BiometricAuthBloc>().stream.listen((state) {
      if (state is BiometricLoginSuccess) {
        context.read<LoginBloc>().add(
              LoginButtonPressed(
                email: state.email,
                password: state.password,
              ),
            );
      } else if (state is BiometricAuthError) {
        _showSnackbar(context, state.message);
      }
    });
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, AppLocalizations.of(context)!.email),
            _buildTextField(
              controller: _emailController,
              icon: "assets/icons/email.svg",
              validator: (value) => value!.isEmpty
                  ? AppLocalizations.of(context)!.elNombreEsObligatorio
                  : null,
            ),
            const SizedBox(height: 12),
            _buildLabel(context, AppLocalizations.of(context)!.password),
            _buildTextField(
              controller: _passwordController,
              icon: "assets/icons/password.svg",
              obscureText: true,
              validator: (value) => value!.isEmpty
                  ? AppLocalizations.of(context)!.elNombreEsObligatorio
                  : null,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => signIn(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF77D8E),
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.textbuttonlogin,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<BiometricAuthBloc, BiometricAuthState>(
              builder: (context, state) {
                if (state is BiometricAuthInitial) {
                  context.read<BiometricAuthBloc>().add(LoadBiometricStatus());
                  return const SizedBox.shrink();
                }

                if (state is BiometricStatusLoaded && state.isEnabled) {
                  return ElevatedButton.icon(
                    onPressed: () => signInWithBiometrics(context),
                    icon: const Icon(Icons.fingerprint),
                    label: Text(
                      AppLocalizations.of(context)!.textbuttonloginBiometrico,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF77D8E),
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String icon,
    required String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SvgPicture.asset(icon),
        ),
      ),
    );
  }
}
