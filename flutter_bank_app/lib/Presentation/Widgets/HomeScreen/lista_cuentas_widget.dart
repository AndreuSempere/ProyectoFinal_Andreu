import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_state.dart';
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Total cuentas disponibles: ${accountState.accounts.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: accountState.accounts.length,
                  itemBuilder: (context, index) {
                    final account = accountState.accounts[index];
                    final accountTypeText =
                        tipoCuenta[account.accountType] ?? 'Desconocido';

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 2,
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              'Cuenta $accountTypeText',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Nº cuenta ${account.numeroCuenta}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
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
                                    Text(' Fecha creada ${account.createdAt}'),
                                  ],
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
