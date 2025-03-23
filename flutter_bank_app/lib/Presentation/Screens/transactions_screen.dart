import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bank_app/Presentation/Screens/graficos_screen.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/Actions/actions_account_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/filtrer_transactions_widget.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Transactions/transactions_list_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TransactionInfoPage extends StatefulWidget {
  final int accountId;
  final String description;
  final String numeroCuenta;

  const TransactionInfoPage(
      {super.key,
      required this.accountId,
      required this.description,
      required this.numeroCuenta});

  @override
  State<TransactionInfoPage> createState() => _TransactionInfoPageState();
}

class _TransactionInfoPageState extends State<TransactionInfoPage> {
  ValueNotifier<int> appliedFiltersCount = ValueNotifier<int>(0);
  Map<String, dynamic> currentFilters = {
    'descripcion': null,
    'tipo': null,
    'created_at': null,
    'cantidad': null,
  };

  void _updateFiltersCount(int count) {
    appliedFiltersCount.value = count;
  }

  void _updateFilters(Map<String, dynamic> filters) {
    // setState(() {
    //   currentFilters = filters;
    // });
  }

  @override
  void dispose() {
    appliedFiltersCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<TransactionBloc>()
        .add(GetAllTransactions(id: widget.accountId));

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 244, 244, 244),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.titleTransactions,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 133, 188, 225),
              ),
            ),
            Text(
              'Nº cuenta ${widget.numeroCuenta}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    size: 32,
                    color: Color.fromARGB(255, 154, 174, 208),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ActionsAccountWidget(
                            accountId: widget.accountId);
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.payment,
                    size: 32,
                    color: Color.fromARGB(255, 154, 174, 208),
                  ),
                  onPressed: () {
                    context.go('/add_card', extra: widget.accountId);
                  },
                ),
                IconButton(
                  icon: ValueListenableBuilder<int>(
                    valueListenable: appliedFiltersCount,
                    builder: (context, count, child) {
                      return Icon(
                        Icons.filter_list,
                        size: 32,
                        color: count > 0
                            ? Colors.red
                            : const Color.fromARGB(255, 154, 174, 208),
                      );
                    },
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FilterDialog(
                          accountId: widget.accountId,
                          onFiltersApplied: _updateFiltersCount,
                          currentFilters: currentFilters,
                        );
                      },
                    ).then((result) {
                      if (result != null) {
                        _updateFilters(result);
                      }
                    });
                  },
                ),
                ValueListenableBuilder<int>(
                  valueListenable: appliedFiltersCount,
                  builder: (context, count, child) {
                    if (count > 0) {
                      return Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.bar_chart,
                    size: 32,
                    color: Color.fromARGB(255, 154, 174, 208),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StatisticsPage(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.qr_code,
                    size: 32,
                    color: Color.fromARGB(255, 154, 174, 208),
                  ),
                  onPressed: () {
                    context.push('/qr_page', extra: widget.accountId);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.blueAccent),
            const SizedBox(height: 10),
            Expanded(
              child: TransactionListWidget(accountId: widget.accountId),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
