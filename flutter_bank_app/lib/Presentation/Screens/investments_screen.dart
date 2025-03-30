import 'package:flutter/material.dart';

class InvestmentsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> investments = [
    {'name': 'Apple', 'shares': 50, 'price': 150.0},
    {'name': 'Google', 'shares': 30, 'price': 2800.0},
    {'name': 'Amazon', 'shares': 10, 'price': 3400.0},
  ];

  InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Investments'),
      ),
      body: ListView.builder(
        itemCount: investments.length,
        itemBuilder: (context, index) {
          final investment = investments[index];
          return ListTile(
            title: Text(investment['name']),
            subtitle: Text('Shares: ${investment['shares']}'),
            trailing: Text('\$${investment['price']}'),
          );
        },
      ),
    );
  }
}
