import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Widgets/HomeScreen/button_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFFFAFAFA),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      size: 38,
                    ),
                    title: Text(
                      'Saldo disponível',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text('R\$ 5.000,00',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.savings,
                      size: 38,
                    ),
                    title: Text(
                      'Dinheiro guardado',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text('R\$ 75.000,00',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.timeline,
                      size: 38,
                    ),
                    title: Text(
                      'Rendimento',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text('R\$ +2.856,23',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: ButtonsMenu(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, right: 8.0, bottom: 5.0, left: 8.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.credit_card, size: 40),
                      title: Text('Meus cartões'),
                      subtitle: Text('Visa **48'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, right: 8.0, bottom: 5.0, left: 8.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.business_center, size: 40),
                      title: Text('Limite de empréstimo'),
                      subtitle: Text('R\$ 20.000,00'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, right: 8.0, bottom: 5.0, left: 8.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.shopping_bag, size: 40),
                      title: Text('Shopping'),
                      subtitle: Text('5% de cashback em lojas parceiras'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, right: 8.0, bottom: 5.0, left: 8.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.cached, size: 40),
                      title: Text('Câmbio internacional'),
                      subtitle: Text('Troque seu dinheiro por dolar ou euro'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, right: 8.0, bottom: 5.0, left: 8.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.language, size: 40),
                      title: Text('Open finance'),
                      subtitle: Text('Mais autonomia e as melhores ofertas'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
