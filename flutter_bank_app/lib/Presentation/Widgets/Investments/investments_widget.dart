import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class InvestmentsWidget extends StatelessWidget {
  const InvestmentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

    return BlocBuilder<InvestmentsBloc, InvestmentsState>(
      builder: (context, investmentsState) {
        if (investmentsState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (investmentsState.errorMessage.isNotEmpty) {
          return Center(child: Text(investmentsState.errorMessage));
        } else if (investmentsState.investments.isNotEmpty) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: investmentsState.investments.length,
                  itemBuilder: (context, index) {
                    final investment = investmentsState.investments[index];

                    final double purchasePrice =
                        investment.purchase_price ?? 0.0;
                    final double currentValue = investment.current_value ?? 0.0;
                    final double amountInvested = investment.amount ?? 0.0;

                    final double quantity =
                        purchasePrice > 0 ? amountInvested / purchasePrice : 0;

                    final double profitOrLoss =
                        (quantity * currentValue) - amountInvested;
                    final bool isProfit = profitOrLoss >= 0;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inversión #${index + 1}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              investment.nameTrading!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monto invertido:',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Text(
                                  currencyFormatter
                                      .format(investment.amount ?? 0.0),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Precio de compra:',
                                    style: TextStyle(color: Colors.grey[700])),
                                Text(currencyFormatter.format(purchasePrice)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Valor actual:',
                                    style: TextStyle(color: Colors.grey[700])),
                                Text(currencyFormatter.format(currentValue)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Ganancia/Pérdida:',
                                    style: TextStyle(color: Colors.grey[700])),
                                Text(
                                  currencyFormatter.format(profitOrLoss),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isProfit ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Fecha de compra:',
                                    style: TextStyle(color: Colors.grey[700])),
                                Text(investment.purchase_date ?? 'N/A'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Última actualización:',
                                    style: TextStyle(color: Colors.grey[700])),
                                Text(investment.last_updated ?? 'N/A'),
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
            child: Text('No tienes ninguna inversión todavía.'),
          );
        }
      },
    );
  }
}
