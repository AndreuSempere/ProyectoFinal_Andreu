import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/accounts/account_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/transaction_page_screen.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/add_money.dart';
import 'package:flutter_bank_app/Presentation/Screens/home_screen.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/delete_account_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionsAccountWidget extends StatelessWidget {
  final int accountId;

  const ActionsAccountWidget({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        AppLocalizations.of(context)!.titleactionTransaction,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            context: context,
            label: AppLocalizations.of(context)!.textaddmoney,
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
            label: AppLocalizations.of(context)!.texttransactionmoney,
            icon: Icons.monetization_on,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionPage(
                    accountId: accountId,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildButton(
            context: context,
            label: AppLocalizations.of(context)!.textbizummoney,
            icon: Icons.send,
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
              label: AppLocalizations.of(context)!.titledelete,
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
          child: Text(AppLocalizations.of(context)!.buttoncancel),
        ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color color = const Color.fromARGB(255, 66, 105, 138),
  }) {
    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
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
