import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordCambiarDialog extends StatefulWidget {
  const PasswordCambiarDialog({super.key});

  @override
  _PasswordResetDialogState createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordCambiarDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Cambiar Contraseña",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Introduce tu correo electrónico para cambiar la contraseña."),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Correo electrónico",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor, ingresa un correo electrónico";
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return "Por favor, ingresa un correo válido";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              String email = _emailController.text;
              context.read<LoginBloc>().add(
                    ResetPasswordEvent(email: email),
                  );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Correo enviado para cambiar contraseña")),
              );
            }
          },
          child: const Text("Enviar"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
