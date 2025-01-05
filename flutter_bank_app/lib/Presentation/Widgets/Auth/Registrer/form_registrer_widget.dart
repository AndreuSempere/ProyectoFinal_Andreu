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

      try {
        // Await the registration process
        context.read<LoginBloc>().add(RegisterButtonPressed(
              email: email,
              password: password,
            ));

        // If registration is successful, proceed to create the new user
        context
            .read<LoginBloc>()
            .add(NewUserEvent(name, surname, email, password, dni, age));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Usuario $name $surname registrado correctamente.')),
        );

        Navigator.pop(context);
      } catch (e) {
        // Handle the exception and show the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
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
          _buildFormRow(
            "Edad:",
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                hintText: 'Introduce tu edad',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.number,
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La edad no puede estar vacía';
                }
                final age = int.tryParse(value);
                if (age == null) {
                  return 'Por favor, ingresa un número válido';
                }
                if (age < 18) {
                  return 'La edad debe ser mayor o igual a 18';
                }

                return null;
              },
            ),
          ),
          _buildFormRow(
            "DNI:",
            TextFormField(
              controller: _dniController,
              decoration: const InputDecoration(
                hintText: 'Introduce tu DNI',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Rellenar el DNI es obligatorio';
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
