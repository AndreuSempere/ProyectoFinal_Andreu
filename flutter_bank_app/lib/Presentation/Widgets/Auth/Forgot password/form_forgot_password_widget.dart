import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordResetDialog extends StatefulWidget {
  const PasswordResetDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordResetDialogState createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text("Recuperar Contraseña"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Introduce tu correo electrónico"),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Correo electrónico",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              String email = _emailController.text;
              if (email.isNotEmpty) {
                context.read<LoginBloc>().add(
                      ResetPasswordEvent(email: email),
                    );
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Por favor, ingresa un correo electrónico")),
                );
              }
            },
            child: const Text("Enviar"),
          ),
        ],
      ),
    );
  }
}
