import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Config/Theme/card_colors.dart';

class CardBack extends StatelessWidget {
  final int cardColor;
  final int cardCvv;

  const CardBack({super.key, required this.cardColor, required this.cardCvv});

  @override
  Widget build(BuildContext context) {
    int colorIndex = (cardColor >= 0 && cardColor < CardColor.baseColors.length)
        ? cardColor
        : 0;

    return Container(
      decoration: BoxDecoration(
        color: CardColor.baseColors[colorIndex],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50.0),
            Row(
              children: <Widget>[
                const Image(
                  image: AssetImage('assets/credit_card/card_band.jpg'),
                  width: 200.0,
                ),
                const SizedBox(width: 15.0),
                Container(
                  width: 65.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Colors.red, width: 3.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      cardCvv.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Bankify',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
