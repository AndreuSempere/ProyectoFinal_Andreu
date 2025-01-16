import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/Edit%20User/plantilla_form_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: Text(
        AppLocalizations.of(context)!.titleUpdUser,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlantillaTextField(
                controller: _nameController,
                label: AppLocalizations.of(context)!.nameUpdUser,
                icon: Icons.person,
                validatorMsg: 'Introduce un nuevo nombre de usuario',
              ),
              PlantillaTextField(
                controller: _surnameController,
                label: AppLocalizations.of(context)!.surnameUpdUser,
                icon: Icons.person_outline,
                validatorMsg: 'Introduce nuevos apellidos',
              ),
              PlantillaTextField(
                controller: _edadController,
                label: AppLocalizations.of(context)!.ageUpdUser,
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validatorMsg: 'Introduce una nueva edad',
                customValidator: (value) {
                  if (int.tryParse(value!) == null ||
                      int.parse(value) <= 0 ||
                      int.parse(value) < 18) {
                    return 'Introduce una edad válida';
                  }
                  return null;
                },
              ),
              PlantillaTextField(
                controller: _dniController,
                label: 'DNI',
                icon: Icons.badge,
                validatorMsg: 'Introduce un nuevo DNI',
                customValidator: (value) {
                  if (!RegExp(r'^\d{8}[A-Za-z]$').hasMatch(value!)) {
                    return 'Introduce un DNI válido (8 números y 1 letra)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.buttoncancel),
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
          child: Text(
            AppLocalizations.of(context)!.buttonguardar,
          ),
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
