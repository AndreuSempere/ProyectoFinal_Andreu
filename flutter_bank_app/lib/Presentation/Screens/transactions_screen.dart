import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/actions_account_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/filtrer_transactions_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/transactions_list_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionInfoPage extends StatelessWidget {
  final int accountId;
  final String description;
  final String numeroCuenta;

  const TransactionInfoPage(
      {super.key,
      required this.accountId,
      required this.description,
      required this.numeroCuenta});

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
      body: Container(
        color: const Color.fromARGB(255, 244, 244, 244),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.titleTransactions,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 133, 188, 225),
              ),
            ),
            Text(
              'Nº cuenta $numeroCuenta',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    size: 32,
                    color: Color.fromARGB(255, 154, 174, 208),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ActionsAccountWidget(accountId: accountId);
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_list,
                    size: 32,
                    color: Color.fromARGB(255, 154, 174, 208),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const FilterDialog();
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.blueAccent),
            const SizedBox(height: 10),
            Expanded(
              child: TransactionListWidget(
                accountId: accountId,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
