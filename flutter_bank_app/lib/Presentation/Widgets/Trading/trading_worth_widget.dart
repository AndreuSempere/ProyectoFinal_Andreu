import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WorthTrading extends StatelessWidget {
  const WorthTrading({super.key, required String name});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, tradingState) {
        if (tradingState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (tradingState.tradings.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                              value.toInt());
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('MM/dd').format(date),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: tradingState.tradings.map((transaction) {
                        return FlSpot(
                          (transaction.recordedAt?.millisecondsSinceEpoch ?? 0)
                              .toDouble(),
                          transaction.price ?? 0.0,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('No transactions found'));
        }
      },
    );
  }
}
