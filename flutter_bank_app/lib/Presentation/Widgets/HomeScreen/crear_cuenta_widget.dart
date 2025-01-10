import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrearCuentaWidget extends StatefulWidget {
  const CrearCuentaWidget({super.key});

  @override
  _CrearCuentaState createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuentaWidget> {
  final _tipoCuentaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedAccountType;

  final Map<String, String> _accountTypes = {
    '1': "Corriente",
    '2': "Ahorros",
    '3': "Inversiones",
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Nueva Cuenta'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Tipo de Cuenta:'),
              value: _selectedAccountType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAccountType = newValue;
                });
              },
              items:
                  _accountTypes.entries.map<DropdownMenuItem<String>>((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Seleccione un tipo de inventario';
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
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final int tipoCuenta =
                  int.tryParse(_selectedAccountType ?? '1') ?? 1;
              const saldoInicial = 0.0;

              final myLoginState = context.read<LoginBloc>().state;
              final userid = myLoginState.user?.idUser;
              if (userid == null) {
                return;
              }

              final newAccount = Account(
                numeroCuenta: _generateAccountNumber(),
                saldo: saldoInicial,
                estado: 'Activo',
                accountType: tipoCuenta,
                idUser: userid,
              );

              context.read<AccountBloc>().add(
                    CreateAccount(newAccount),
                  );
              Navigator.of(context).pop(); // Cerrar el diálogo
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  /// Genera un número de cuenta de 16 dígitos aleatorio.
  String _generateAccountNumber() {
    final random = Random();
    const int length = 16;
    String accountNumber = '';

    for (int i = 0; i < length; i++) {
      accountNumber +=
          random.nextInt(10).toString(); // Genera dígitos del 0 al 9
    }

    return accountNumber;
  }

  @override
  void dispose() {
    _tipoCuentaController.dispose();
    super.dispose();
  }
}
