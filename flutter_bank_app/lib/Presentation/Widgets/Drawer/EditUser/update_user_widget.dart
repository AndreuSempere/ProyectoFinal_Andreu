import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/EditUser/template_form_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';

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
      _edadController.text = myLoginState.user!.age?.toString() ?? '';
      _dniController.text = myLoginState.user!.dni ?? '';
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
              const SizedBox(height: 8),
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

              final myLoginState = context.read<LoginBloc>().state;
              final String email = myLoginState.user!.email;
              final int? idUser = myLoginState.user!.idUser;
              final int telf = 0;

              context.read<LoginBloc>().add(
                    UpdateUserEvent(idUser!, name, surname, email, telf),
                  );

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
