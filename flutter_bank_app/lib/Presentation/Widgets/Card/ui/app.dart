import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Widgets/Drawer/drawer_widget.dart';
import '../ui/widgets/card_list.dart';
import '../ui/card_type.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Wallet',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CardType()));
              },
            )
          ]),
      drawer: const DrawerWidget(),
      body: const CardList(),
    );
  }
}
