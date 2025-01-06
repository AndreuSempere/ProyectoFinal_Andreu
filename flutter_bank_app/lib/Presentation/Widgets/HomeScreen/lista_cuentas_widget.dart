import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_state.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountListWidget extends StatelessWidget {
  const AccountListWidget({super.key});

  // Lista de posibles tipos de cuenta
  static const Map<int, String> tipoCuenta = {
    1: "Corriente",
    2: "Ahorros",
    3: "Inversiones",
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        if (accountState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (accountState.errorMessage.isNotEmpty) {
          return Center(child: Text(accountState.errorMessage));
        } else if (accountState.accounts.isNotEmpty) {
          final myLoginState = context.read<LoginBloc>().state;
          final userid = myLoginState.user?.idUser;

          // Filtrar cuentas asociadas al usuario
          final userAccounts = accountState.accounts
              .where((account) => account.idUser == userid)
              .toList();

          if (userAccounts.isEmpty) {
            return const Center(
              child: Text(
                  'No tienes ninguna cuenta registrada. Empieza creando una!'),
            );
          }

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: userAccounts.length,
                  itemBuilder: (context, index) {
                    final account = userAccounts[index];
                    final accountTypeText =
                        tipoCuenta[account.accountType] ?? 'Desconocido';

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cuenta $accountTypeText',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Nº cuenta ${account.numeroCuenta}',
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${account.saldo}€',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                Text(
                                  'Fecha creada ${account.createdAt}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('No hay cuentas asociadas a este usuario.'),
          );
        }
      },
    );
  }
}
