import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListWidget extends StatelessWidget {
  final int accountId;

  const TransactionListWidget({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, transactionState) {
        if (transactionState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (transactionState.errorMessage.isNotEmpty) {
          return Center(child: Text(transactionState.errorMessage));
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
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${transaction.descripcion}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${transaction.tipo == 'ingreso' ? '+' : '-'}${transaction.cantidad}€',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: transaction.tipo == 'ingreso'
                                        ? Colors.black
                                        : Colors.red,
                                  ),
                                ),
                                Text(
                                  'Fecha: ${transaction.created_at}',
                                  style: const TextStyle(fontSize: 16),
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
            child: Text('No hay transacciones para esta cuenta.'),
          );
        }
      },
    );
  }
}
