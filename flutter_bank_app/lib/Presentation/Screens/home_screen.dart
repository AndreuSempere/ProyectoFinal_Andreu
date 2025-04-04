import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_state.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/drawer_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/create_account_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/list_accounts_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 23),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          AppLocalizations.of(context)!
                              .titleHomeScreen(state.user!.name),
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
                    const SizedBox(height: 30),
                    Expanded(
                        child: AccountListWidget(userId: state.user!.idUser!)),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('No hay información del usuario'),
              );
            }
          },
        ));
  }
}
