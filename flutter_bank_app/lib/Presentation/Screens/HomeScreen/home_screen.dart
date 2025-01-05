import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/auth/login_state.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/drawer_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/crear_cuenta_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/lista_cuentas_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<LoginBloc>().add(FetchUserDataEvent());
    context.read<AccountBloc>().add(GetAllAccount());

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Bankify')),
      ),
      drawer: const DrawerWidget(),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (state.user != null) {
            return Column(
              children: [
                const SizedBox(height: 23),
                Center(
                  child: Text(
                    'Hola ${state.user!.name}! aquí tienes tu listado de cuentas',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 100),
                const Expanded(child: AccountListWidget()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CrearCuentaWidget();
                          },
                        );
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(
                      height: 80,
                      width: 10,
                    )
                  ],
                )
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
