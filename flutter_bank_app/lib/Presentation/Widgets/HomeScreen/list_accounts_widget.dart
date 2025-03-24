import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_state.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AccountListWidget extends StatefulWidget {
  final int userId;
  const AccountListWidget({super.key, required this.userId});

  @override
  State<AccountListWidget> createState() => _AccountListWidgetState();
}

class _AccountListWidgetState extends State<AccountListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(GetAllAccount(userId: widget.userId));
  }

  final Map<String, IconData> iconOptions = {
    'bank': Icons.account_balance,
    'piggy': Icons.savings,
    'investment': Icons.trending_up,
    'wallet': Icons.account_balance_wallet,
  };

  @override
  Widget build(BuildContext context) {
    final Map<int, String> tipoCuenta = {
      1: AppLocalizations.of(context)!.accountType1,
      2: AppLocalizations.of(context)!.accountType2,
      3: AppLocalizations.of(context)!.accountType3,
    };
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        if (accountState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (accountState.errorMessage.isNotEmpty &&
            accountState.accounts.isEmpty) {
          return Center(child: Text('Error: ${accountState.errorMessage}'));
        } else if (accountState.accounts.isNotEmpty) {
          final myLoginState = context.watch<LoginBloc>().state;
          final userid = myLoginState.user?.idUser;

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
                      color: const Color.fromARGB(255, 143, 193, 226),
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  accountTypeText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(iconOptions[account.icon],
                                    size: 30,
                                    color: const Color.fromARGB(255, 6, 6, 6)),
                              ],
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
                                Text('Fecha creada ${account.createdAt}'),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          if (account.accountType != 3) {
                            context.push(
                              '/transactions',
                              extra: account,
                            );
                          } else {
                            context.push('/trading', extra: account.idCuenta);
                          }
                        },
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
