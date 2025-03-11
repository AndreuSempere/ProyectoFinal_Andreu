import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TradingListWidget extends StatelessWidget {
  const TradingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, tradingState) {
        if (tradingState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (tradingState.tradings.isNotEmpty) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tradingState.tradings.length,
                  itemBuilder: (context, index) {
                    final transaction = tradingState.tradings[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: InkWell(
                      onTap: () {
                         context.push(
                            '/worth_trading',
                            extra: transaction.name,
                          );
                      },
                      child: ListTile(
                        title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          transaction.name ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                          'Symbol: ${transaction.symbol ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                          ),
                        ],
                        ),
                        subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                          'Type: ${transaction.type ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Text(
                          'Precio: \$${transaction.price?.toString() ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Text(
                          'Fecha: ${transaction.recordedAt != null ? DateFormat.yMMMd().format(transaction.recordedAt!) : 'N/A'}',
                          style: const TextStyle(fontSize: 14),
                          ),
                        ],
                        ),
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
            child: Text('No hay datos para mostrar.'),
          );
        }
      },
    );
  }
}
