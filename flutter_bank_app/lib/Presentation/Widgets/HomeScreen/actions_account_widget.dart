import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_event.dart';
import 'package:flutter_bank_app/Presentation/Screens/add_money.dart';
import 'package:flutter_bank_app/Presentation/Screens/home_screen.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/delete_account_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionsAccountWidget extends StatelessWidget {
  final int accountId;

  const ActionsAccountWidget({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Que quieres hacer?',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            context: context,
            label: 'Añadir dinero',
            icon: Icons.money,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMoneyPage(
                    accountId: accountId,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildButton(
              context: context,
              label: 'Eliminar Cuenta',
              icon: Icons.delete,
              onPressed: () async {
                final resultado = await _mostrarAlerta(context);
                if (resultado == "Aceptar") {
                  context
                      .read<AccountBloc>()
                      .add(DeleteAccountEvent(id: accountId));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }
              }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancelar');
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

Future<String?> _mostrarAlerta(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return const DialogAlertaDelete();
    },
  );
}
