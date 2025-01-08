import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/filtrer_transactions_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/transactions_list_widget.dart';

class TransactionInfoPage extends StatelessWidget {
  final int accountId;

  const TransactionInfoPage({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Bankify',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.blue,
              )),
        ),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Movimientos de Cuenta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, right: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const FilterDialog();
              },
            );
          },
          backgroundColor: const Color.fromARGB(255, 154, 174, 208),
          child: const Icon(Icons.filter_list),
        ),
      ),
    );
  }
}
