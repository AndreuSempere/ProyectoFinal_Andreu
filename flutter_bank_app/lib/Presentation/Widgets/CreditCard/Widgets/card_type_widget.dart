import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/CrearCard/Style/my_appbar.dart';
import '../CrearCard/card_create.dart';

class CardType extends StatelessWidget {
  final int accountId;
  const CardType({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    final buildTextInfo = Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: Text.rich(
        TextSpan(
          text:
              'You can now add gift cards with a specific balance into wallet. When the card hits \$0.00 it will automatically disappear. Want to know if your gift card will link? ',
          style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
          children: const <TextSpan>[
            TextSpan(
              text: 'Learn More',
              style: TextStyle(
                  color: Colors.lightBlue, fontWeight: FontWeight.bold),
            )
          ],
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );

    return Scaffold(
      appBar: MyAppBar(
        appBarTitle: 'Select Type',
        leadingIcon: Icons.clear,
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildCardTypeButton(context, 'Credit Card', Colors.lightBlue),
            _buildCardTypeButton(context, 'Debit Card', Colors.grey[100]!),
            _buildCardTypeButton(context, 'Gift Card', Colors.grey[100]!),
            buildTextInfo,
          ],
        ),
      ),
    );
  }

  Widget _buildCardTypeButton(
      BuildContext context, String buttonText, Color buttonColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CardCreate(cardType: buttonText, accountId: accountId),
            ),
          );
        },
        style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
        child: Text(buttonText, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
