import 'package:flutter/material.dart';

class CardChip extends StatelessWidget {
  const CardChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Image(
        image: AssetImage('assets/credit_card/creditcardchipsilver.png'),
        width: 50.0,
      ),
    );
  }
}
