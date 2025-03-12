import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WorthTrading extends StatelessWidget {
    const WorthTrading({super.key});

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
                                        return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                                children: [
                                                    SizedBox(
                                                        height: 200,
                                                        child: LineChart(
                                                            LineChartData(
                                                                gridData: FlGridData(show: false),
                                                                titlesData: FlTitlesData(
                                                                    bottomTitles: SideTitles(
                                                                        showTitles: true,
                                                                        getTextStyles: (context, value) => const TextStyle(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 12,
                                                                        ),
                                                                        getTitles: (value) {
                                                                            final date = DateTime.fromMillisecondsSinceEpoch(transaction.recordedAt.toInt());
                                                                            return DateFormat('MM/dd').format(date);
                                                                        },
                                                                    ),
                                                                    leftTitles: SideTitles(showTitles: false),
                                                                ),
                                                                borderData: FlBorderData(show: false),
                                                                lineBarsData: [
                                                                    LineChartBarData(
                                                                        spots: transaction.values.map((value) {
                                                                            return FlSpot(
                                                                                value.date.millisecondsSinceEpoch.toDouble(),
                                                                                value.price,
                                                                            );
                                                                        }).toList(),
                                                                        isCurved: true,
                                                                        colors: [Colors.blue],
                                                                        barWidth: 2,
                                                                        belowBarData: BarAreaData(show: false),
                                                                    ),
                                                                ],
                                                            ),
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
                    return const Center(child: Text('No transactions found'));
                }
            },
        );
    }
}