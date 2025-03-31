import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_state.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Trading/build_price_card_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Trading/modal_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class WorthTrading extends StatelessWidget {
  final String name;
  final int accountId;

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
    {'name': 'Gas_natural', 'icon': 'assets/icon_trading/gas_natural.png'},
    {'name': 'Google', 'icon': 'assets/icon_trading/google.png'},
    {'name': 'Microsoft', 'icon': 'assets/icon_trading/microsoft.png'},
    {'name': 'Solana', 'icon': 'assets/icon_trading/solana.png'},
    {'name': 'Cardano', 'icon': 'assets/icon_trading/cardano.png'},
  ];

  WorthTrading({super.key, required this.name, required this.accountId});

  @override
  Widget build(BuildContext context) {
    context.read<TradingBloc>().add(GetRecordTrading(name: name));
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 33, 150, 243),
                Color.fromARGB(255, 143, 193, 226)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Trading Market',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TradingBloc, TradingState>(
        builder: (context, tradingState) {
          if (tradingState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (tradingState.tradingRecords.isNotEmpty) {
            final List<TradingEntity> sortedTradings = [
              ...tradingState.tradingRecords
            ]..sort((a, b) => (a.recordedAt ?? DateTime.now())
                .compareTo(b.recordedAt ?? DateTime.now()));

            final double todayPrice = sortedTradings.last.price ?? 0.0;
            final double threeDaysAgoPrice = sortedTradings.length > 3
                ? sortedTradings[sortedTradings.length - 4].price ?? 0.0
                : 0.0;
            final double sevenDaysAgoPrice = sortedTradings.length > 7
                ? sortedTradings[sortedTradings.length - 8].price ?? 0.0
                : 0.0;

            final currencyFormatter = NumberFormat.currency(
                locale: 'en_US', symbol: '\$', decimalDigits: 2);

            final iconData = materialIcons.firstWhere(
              (element) => element['name'] == name,
            );

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 7, 11, 129),
                              ),
                            ),
                            Text(
                              'Symbol: ${tradingState.tradingRecords.last.symbol}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Image.asset(
                          iconData['icon'] ?? 'assets/icon_trading/default.png',
                          width: 65,
                          height: 65,
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.blueAccent),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildPriceCard('Hoy', todayPrice, currencyFormatter),
                        buildPriceCard('Hace 3 días', threeDaysAgoPrice,
                            currencyFormatter),
                        buildPriceCard('Hace 7 días', sevenDaysAgoPrice,
                            currencyFormatter),
                      ],
                    ),
                  ),
                  // Gráfico
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                                color: Colors.blueGrey.withOpacity(0.2)),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: sortedTradings.map((transaction) {
                                return FlSpot(
                                  transaction.recordedAt!.millisecondsSinceEpoch
                                      .toDouble(),
                                  transaction.price ?? 0.0,
                                );
                              }).toList(),
                              isCurved: true,
                              color: const Color.fromARGB(255, 244, 244, 244),
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter:
                                    (spot, percent, barData, index) =>
                                        FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.blue,
                                  strokeWidth: 1.5,
                                  strokeColor: Colors.white,
                                ),
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Botones
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final cantidad = await showModalBottomSheet<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return const ModalWidget(
                                  title: 'Comprar',
                                  actionLabel: 'Enviar',
                                );
                              },
                            );

                            if (cantidad != null && cantidad.isNotEmpty) {
                              print('Cantidad ingresada: $cantidad');

                              context
                                  .read<InvestmentsBloc>()
                                  .add(CreateInvestment(
                                    symbol: tradingState
                                            .tradingRecords.last.symbol ??
                                        '',
                                    amount: double.parse(cantidad),
                                    accountId: accountId,
                                  ));
                              context.go('/home');
                            }
                          },
                          child: const Text('Comprar'),
                        ),
                      ],
                    ),
                  ),

                  //Acordeón
                  ExpansionTile(
                    title: const Text(
                      'Ver registros históricos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    children: [
                      SizedBox(
                        height: 350,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: sortedTradings.length,
                          itemBuilder: (context, index) {
                            final trading = sortedTradings[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: ListTile(
                                title: Text(currencyFormatter
                                    .format(trading.price ?? 0.0)),
                                subtitle: Text(DateFormat.yMMMd()
                                    .add_jm()
                                    .format(trading.recordedAt!)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No trading data available',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            );
          }
        },
      ),
    );
  }
}
