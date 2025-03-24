import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionListWidget extends StatelessWidget {
  final int accountId;

  const TransactionListWidget({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, transactionState) {
        if (transactionState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (transactionState.errorMessage.isNotEmpty &&
            transactionState.transactions.isEmpty) {
          if (transactionState.transactions.isEmpty) {
            return const Center(
                child: Text('No hay transacciones para esta cuenta.'));
          } else {
            return Center(child: Text(transactionState.errorMessage));
          }
        } else if (transactionState.transactions.isNotEmpty) {
          final transactionAccounts = transactionState.transactions
              .where((transaction) => transaction.account == accountId)
              .toList();
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactionAccounts.length,
                  itemBuilder: (context, index) {
                    final transaction = transactionAccounts[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${transaction.created_at} -  ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 19,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${transaction.tipo == 'ingreso' ? '+' : '-'}${transaction.cantidad}€',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: transaction.tipo == 'ingreso'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.descripcion!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                if (transaction.receipt_url != null)
                                  GestureDetector(
                                    onTap: () async {
                                      final url = transaction.receipt_url!;
                                      print("URL del PDF: $url");

                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        await launchUrl(Uri.parse(url),
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        print("No se pudo abrir el PDF");
                                      }
                                    },
                                    child: Text(
                                      'Ver recibo',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('No hay transacciones para esta cuenta.'),
          );
        }
      },
    );
  }
}
