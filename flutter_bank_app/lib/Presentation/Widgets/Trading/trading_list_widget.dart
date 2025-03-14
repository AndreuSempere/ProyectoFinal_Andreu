import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
          final Map<String, List<dynamic>> groupedTrades = {};
          for (var trade in tradingState.tradings) {
            final type = trade.type ?? 'Otros';
            groupedTrades.putIfAbsent(type, () => []).add(trade);
          }

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Expanded(
                child: ListView(
                  children: groupedTrades.entries.expand((entry) {
                    return [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      ...entry.value.map((transaction) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: InkWell(
                            onTap: () {
                              context.push(
                                '/worth_trading',
                                extra: transaction.name,
                              );
                            },
                            child: ListTile(
                              title: Text(
                                transaction.name ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                      }),
                    ];
                  }).toList(),
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
