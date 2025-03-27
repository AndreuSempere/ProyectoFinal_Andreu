import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TradingListWidget extends StatelessWidget {
  final int accountid;
  const TradingListWidget({super.key, required this.accountid});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, tradingState) {
        if (tradingState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (tradingState.tradings.isNotEmpty) {
          final Map<String, List<dynamic>> groupedTrades = {};

          final List<Map<String, String>> materialIcons = [
            {'name': 'Apple', 'icon': 'assets/icon_trading/apple.png'},
            {'name': 'Tesla', 'icon': 'assets/icon_trading/tesla.png'},
            {'name': 'Xrp', 'icon': 'assets/icon_trading/xrp.png'},
            {'name': 'Ethereum', 'icon': 'assets/icon_trading/ethereum.png'},
            {'name': 'Bitcoin', 'icon': 'assets/icon_trading/bitcoin.png'},
            {'name': 'Cobre', 'icon': 'assets/icon_trading/cobre.png'},
            {'name': 'Oro', 'icon': 'assets/icon_trading/oro.png'},
            {'name': 'Plata', 'icon': 'assets/icon_trading/plata.png'},
            {'name': 'Petroleo', 'icon': 'assets/icon_trading/petroleo.png'},
            {'name': 'Nvidia', 'icon': 'assets/icon_trading/nvidia.png'},
            {
              'name': 'Gas_natural',
              'icon': 'assets/icon_trading/gas_natural.png'
            },
            {'name': 'Google', 'icon': 'assets/icon_trading/google.png'},
            {'name': 'Microsoft', 'icon': 'assets/icon_trading/microsoft.png'},
            {'name': 'Solana', 'icon': 'assets/icon_trading/solana.png'},
            {'name': 'Cardano', 'icon': 'assets/icon_trading/cardano.png'},
          ];

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
                        // Buscar el icono correspondiente al nombre de la transacción
                        final iconData = materialIcons.firstWhere(
                          (element) => element['name'] == transaction.name,
                        );
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: InkWell(
                            onTap: () {
                              context.push(
                                '/worth_trading',
                                extra: {
                                  'transactionName': transaction.name,
                                  'accountId': accountid,
                                },
                              );
                            },
                            child: ListTile(
                              leading: Image.asset(iconData['icon'] ??
                                  'assets/icon_trading/default.png'),
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
