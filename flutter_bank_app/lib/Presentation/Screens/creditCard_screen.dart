import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/credit%20card/creditCard_event.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/card_list_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Widgets/CreditCard/Widgets/card_type_widget.dart';

class HomeCreditCard extends StatelessWidget {
  final int accountId;
  const HomeCreditCard({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    context.read<CreditCardBloc>().add(GetAllCreditCards());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 193, 226),
        title: const Text(
          'Wallet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 249, 249, 249),
          ),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CardType(accountId: accountId)),
                    );
                  },
                  label: Text(
                    AppLocalizations.of(context)!.creaTarjeta,
                    style: const TextStyle(fontSize: 16),
                  ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: CardList()),
          ],
        ),
      ),
    );
  }
}
