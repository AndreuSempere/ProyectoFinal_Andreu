import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dniController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String surname = _surnameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String dni = _dniController.text;
      final String age = _ageController.text;

      context.read<LoginBloc>().add(RegisterButtonPressed(
            email: email,
            password: password,
          ));

      context
          .read<LoginBloc>()
          .add(NewUserEvent(name, surname, email, password, dni, age));

      await Future.delayed(const Duration(seconds: 1));

      final state = context.read<LoginBloc>().state;

      if (state.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.message ??
                  AppLocalizations.of(context)!
                      .usuarioRegistradoCorrectamente)),
        );
        Navigator.pop(context);
      } else if (state.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.message ??
                  AppLocalizations.of(context)!.errorRegistrarUsuario)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error al registrar usuario. Inténtalo de nuevo.')),
      );
    }
  }

  Widget _buildFormRow(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: 7),
          Expanded(child: field),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildFormRow(
            AppLocalizations.of(context)!.nameUpdUser,
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.introduceTuNombre,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.elNombreEsObligatorio;
                }
                return null;
              },
            ),
          ),
          _buildFormRow(
            AppLocalizations.of(context)!.surnameUpdUser,
            TextFormField(
              controller: _surnameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.introduceTuApellido,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.elApellidoEsObligatorio;
                }
                return null;
              },
            ),
          ),
          _buildFormRow(
            AppLocalizations.of(context)!.email,
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.introduceTuEmail,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains("@")) {
                  return AppLocalizations.of(context)!.introduceUnEmailValido;
                }
                return null;
              },
            ),
          ),
          _buildFormRow(
            AppLocalizations.of(context)!.password,
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.introduceTuPassword,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return AppLocalizations.of(context)!
                      .laPasswordDebeTenerAlMenos6Caracteres;
                }
                return null;
              },
            ),
          ),
          _buildFormRow(
            AppLocalizations.of(context)!.ageUpdUser,
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.introduceTuEdad,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.number,
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.laEdadNoPuedeEstarVacia;
                }
                final age = int.tryParse(value);
                if (age == null) {
                  return AppLocalizations.of(context)!
                      .porFavorIngresaUnNumeroValido;
                }
                if (age < 18) {
                  return AppLocalizations.of(context)!
                      .laEdadDebeSerMayorOIgualA18;
                }

                return null;
              },
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.buttoncancel),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: Text(
                  AppLocalizations.of(context)!.buttonguardar,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
