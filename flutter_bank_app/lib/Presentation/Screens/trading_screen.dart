import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Trading/trading_list_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TradingAsset {
  TradingAsset();
}

class TradingScreen extends StatelessWidget {
  const TradingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TradingBloc>().add(GetAllTrading());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
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
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FloatingActionButton.extended(
              onPressed: () {
                context.push('/investment_screen');
              },
              label: Text(
                'Mis inversiones',
                style: const TextStyle(fontSize: 16),
              ),
              icon: const Icon(Icons.show_chart),
            ),
          ]),
          Expanded(child: TradingListWidget()),
        ],
      ),
    );
  }
}
