import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/plantilla_form_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditarUser extends StatefulWidget {
  const EditarUser({super.key});

  @override
  DialogoState createState() => DialogoState();
}

class DialogoState extends State<EditarUser> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _edadController = TextEditingController();
  final _dniController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final myLoginState = context.read<LoginBloc>().state;
    if (myLoginState.user != null) {
      _nameController.text = myLoginState.user!.name;
      _surnameController.text = myLoginState.user!.surname;
      _edadController.text = myLoginState.user!.age!;
      _dniController.text = myLoginState.user!.dni!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Editar Información Usuario',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlantillaTextField(
                controller: _nameController,
                label: 'Nombre Usuario',
                icon: Icons.person,
                validatorMsg: 'Introduce un nuevo nombre de usuario',
              ),
              PlantillaTextField(
                controller: _surnameController,
                label: 'Apellidos',
                icon: Icons.person_outline,
                validatorMsg: 'Introduce nuevos apellidos',
              ),
              PlantillaTextField(
                controller: _edadController,
                label: 'Edad',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validatorMsg: 'Introduce una nueva edad',
              ),
              PlantillaTextField(
                controller: _dniController,
                label: 'DNI',
                icon: Icons.badge,
                validatorMsg: 'Introduce un nuevo DNI',
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              final String name = _nameController.text;
              final String surname = _surnameController.text;
              final String dni = _dniController.text;
              final String age = _edadController.text;

              final myLoginState = context.read<LoginBloc>().state;
              final String email = myLoginState.user!.email;
              final int? idUser = myLoginState.user!.idUser;

              context.read<LoginBloc>().add(
                  UpdateUserEvent(idUser!, name, surname, email, dni, age));

              Navigator.of(context).pop();
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _edadController.dispose();
    _dniController.dispose();
    super.dispose();
  }
}
