import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myTransactionState = context.read<TransactionBloc>().state;
    final transactions = myTransactionState.transactions;

    double totalIngresos = transactions
        .where((t) => t.tipo == "ingreso")
        .fold(0, (sum, t) => sum + t.cantidad);
    double totalGastos = transactions
        .where((t) => t.tipo == "gasto")
        .fold(0, (sum, t) => sum + t.cantidad);
    double balance = totalIngresos - totalGastos;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 193, 226),
        title: const Text(
          'Bankify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildStatisticCard(
                        "Total Ingresos", totalIngresos, Colors.green),
                    const SizedBox(height: 10),
                    _buildStatisticCard(
                        "Total Gastos", totalGastos, Colors.red),
                    const SizedBox(height: 10),
                    _buildStatisticCard("Balance Final", balance,
                        balance >= 0 ? Colors.blue : Colors.redAccent),
                    const SizedBox(height: 20),
                    _buildGraphAccordion(totalIngresos, totalGastos),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  /// Botones de estadísticas
  Widget _buildStatisticCard(String title, double amount, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "\$${amount.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  /// Acordeón
  Widget _buildGraphAccordion(double ingresos, double gastos) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text("📊 Ver Gráfico de Pastel"),
          children: [_buildPieChart(ingresos, gastos)],
        ),
        ExpansionTile(
          title: const Text("📈 Ver Gráfico de Barras"),
          children: [_buildBarChart(ingresos, gastos)],
        ),
        ExpansionTile(
          title: const Text("📉 Ver Gráfico de Líneas"),
          children: [_buildLineChart(ingresos, gastos)],
        ),
      ],
    );
  }

  /// Gráfico de pastel
  Widget _buildPieChart(double ingresos, double gastos) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: ingresos,
              color: Colors.green,
              title: 'Ingresos\n\$${ingresos.toStringAsFixed(2)}',
              radius: 50,
              titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            PieChartSectionData(
              value: gastos,
              color: Colors.red,
              title: 'Gastos\n\$${gastos.toStringAsFixed(2)}',
              radius: 50,
              titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  /// Gráfico de barras
  Widget _buildBarChart(double ingresos, double gastos) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 1,
              barRods: [BarChartRodData(toY: ingresos, color: Colors.green)],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [BarChartRodData(toY: gastos, color: Colors.red)],
            ),
          ],
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
        ),
      ),
    );
  }

  /// Gráfico de líneas
  Widget _buildLineChart(double ingresos, double gastos) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 0),
                FlSpot(1, ingresos),
                FlSpot(2, gastos),
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
