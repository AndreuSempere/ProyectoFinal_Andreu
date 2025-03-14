import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WorthTrading extends StatelessWidget {
  final String name;

  const WorthTrading({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TradingBloc, TradingState>(
        builder: (context, tradingState) {
          if (tradingState.isLoading) {
            return const CircularProgressIndicator();
          } else if (tradingState.tradings.isNotEmpty) {
            // Ordenar datos por fecha
            final List<TradingEntity> sortedTradings = [
              ...tradingState.tradings
            ]..sort((a, b) => (a.recordedAt ?? DateTime.now())
                .compareTo(b.recordedAt ?? DateTime.now()));

            // Calcular precio actual
            final double currentPrice = sortedTradings.last.price ?? 0.0;

            // Formatear precio con separador de miles
            final currencyFormatter = NumberFormat.currency(
              locale: 'en_US',
              symbol: '\$',
              decimalDigits: 2,
            );

            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Título y precio actual
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          sortedTradings.last.symbol ?? name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        Text(
                          currencyFormatter.format(currentPrice),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Gráfico
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.blueGrey.withOpacity(0.2),
                            ),
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
                              color: Colors.blueAccent,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Text(
              'No trading data available',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            );
          }
        },
      ),
    );
  }
}
