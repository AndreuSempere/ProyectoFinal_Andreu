import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_state.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/drawer_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/create_account_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/list_accounts_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LoginBloc>().add(FetchUserDataEvent());
    context.read<TransactionBloc>().add(GetAllTransactions());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 193, 226),
        title: const Text(
          'Bankify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      drawer: const DrawerWidget(),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.message != null) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (state.user != null) {
            final id_user = state.user!.idUser;
            context.read<AccountBloc>().add(GetAllAccount(id: id_user!));

            return Column(
              children: [
                const SizedBox(height: 23),
                Center(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .titleHomeScreen(state.user!.name),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      FloatingActionButton.extended(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CrearCuentaWidget();
                            },
                          );
                        },
                        label: Text(
                          AppLocalizations.of(context)!.creaCuenta,
                          style: const TextStyle(fontSize: 16),
                        ),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(child: AccountListWidget()),
              ],
            );
          } else {
            return const Center(
              child: Text('No hay información del usuario'),
            );
          }
        },
      ),
    );
  }
}
