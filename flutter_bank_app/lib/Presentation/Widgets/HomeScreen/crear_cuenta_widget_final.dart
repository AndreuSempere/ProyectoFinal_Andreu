import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CrearCuentaWidget extends StatefulWidget {
  const CrearCuentaWidget({super.key});

  @override
  _CrearCuentaState createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuentaWidget> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedAccountType;
  String? _selectedIcon;
  final TextEditingController _descriptionController = TextEditingController();

  final Map<String, IconData> _iconOptions = {
    'bank': Icons.account_balance,
    'piggy': Icons.savings,
    'investment': Icons.trending_up,
    'wallet': Icons.account_balance_wallet,
  };

  @override
  Widget build(BuildContext context) {
    final Map<String, String> accountTypes = {
      '1': AppLocalizations.of(context)!.accountType1,
      '2': AppLocalizations.of(context)!.accountType2,
      '3': AppLocalizations.of(context)!.accountType3,
    };

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.titlecreaCuenta),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                final selected = await _selectIcon(context);
                if (selected != null) {
                  setState(() {
                    _selectedIcon = selected;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedIcon != null
                          ? '${AppLocalizations.of(context)!.iconselected} ${_selectedIcon!.capitalize()}'
                          : AppLocalizations.of(context)!.selectedIcon,
                    ),
                    Icon(
                      _selectedIcon != null
                          ? _iconOptions[_selectedIcon]
                          : Icons.add_circle_outline,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.accountType),
              value: _selectedAccountType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAccountType = newValue;
                });
              },
              items:
                  accountTypes.entries.map<DropdownMenuItem<String>>((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.elNombreEsObligatorio;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.descpAccount,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .laDescripcionNoPuedeEstarVacia;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.buttoncancel,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _selectedIcon != null) {
              final int tipoCuenta =
                  int.tryParse(_selectedAccountType ?? '1') ?? 1;
              final String description = _descriptionController.text;

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
                description: description,
                icon: _selectedIcon,
              );

              context.read<AccountBloc>().add(CreateAccount(newAccount));
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

  Future<String?> _selectIcon(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.selecionaIcono),
          children: _iconOptions.entries.map((entry) {
            return SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(entry.key),
              child: Row(
                children: [
                  Icon(entry.value, color: Colors.blue),
                  const SizedBox(width: 16),
                  Text(entry.key.capitalize()),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _generateAccountNumber() {
    final random = Random();
    return List.generate(16, (_) => random.nextInt(10).toString()).join();
  }
}

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
