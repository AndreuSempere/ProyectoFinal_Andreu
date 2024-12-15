import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String surname = _surnameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;

      context
          .read<LoginBloc>()
          .add(RegisterButtonPressed(email: email, password: password));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Usuario $name $surname registrado correctamente.')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
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
          Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'Registrar nuevo usuario',
                style: TextStyle(color: Colors.blue, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _buildFormRow(
            "Nombre:",
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Introduce tu nombre',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
            ),
          ),
          _buildFormRow(
            "Apellido:",
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(
                hintText: 'Introduce tu apellido',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El apellido es obligatorio';
                }
                return null;
              },
            ),
          ),
          _buildFormRow(
            "Email:",
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Introduce tu email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains("@")) {
                  return 'Introduce un email válido';
                }
                return null;
              },
            ),
          ),
          _buildFormRow(
            "Contraseña:",
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Introduce tu contraseña',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
