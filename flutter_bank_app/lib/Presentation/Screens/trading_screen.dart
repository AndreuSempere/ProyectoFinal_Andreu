import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/investments/investments_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/trading/trading_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Investments/investments_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Trading/trading_list_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TradingScreen extends StatefulWidget {
  final int accountid;
  const TradingScreen({super.key, required this.accountid});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TradingBloc>().add(GetAllTrading());
    context
        .read<InvestmentsBloc>()
        .add(GetAllInvestments(accountid: widget.accountid));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(
            _selectedIndex == 0 ? 'Trading Market' : 'Mis Inversiones',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Trading tab
          TradingListWidget(),
          InvestmentsWidget(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 10,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.candlestick_chart),
            label: 'Trading',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Mis Inversiones',
          ),
        ],
      ),
    );
  }
}
