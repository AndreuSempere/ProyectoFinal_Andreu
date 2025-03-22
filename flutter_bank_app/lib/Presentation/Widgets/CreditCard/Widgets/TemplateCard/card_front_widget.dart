import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Config/Theme/card_colors.dart';
import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';
import 'package:flutter_bank_app/Presentation/Widgets/CreditCard/Widgets/TemplateCard/card_chip.dart';

class CardFront extends StatelessWidget {
  final CreditCardEntity card;

  const CardFront({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    int colorIndex =
        (card.cardColor! >= 0 && card.cardColor! < CardColor.baseColors.length)
            ? card.cardColor!
            : 0;

    return Container(
      width: 350,
      height: 220,
      decoration: BoxDecoration(
        color: CardColor.baseColors[colorIndex],
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          /// **Fila superior con el chip y logo de la tarjeta**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const CardChip(),
              Image.asset(
                'assets/credit_card/visa_logo.png',
                width: 50.0,
                height: 25.0,
              ),
            ],
          ),

          /// **Número de tarjeta**
          Text(
            _formatCardNumber(card.numero_tarjeta),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// **Nombre del titular**
              Expanded(
                flex: 3,
                child: Text(
                  card.cardHolderName.isNotEmpty
                      ? card.cardHolderName.toUpperCase()
                      : 'CARDHOLDER NAME',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 10),

              /// **Fecha de vencimiento**
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'VALID THRU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6.0,
                      ),
                    ),
                    Text(
                      _formatMonthYear(card.fecha_expiracion!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCardNumber(String number) {
    if (number.isEmpty) return '0000 0000 0000 0000';
    number = number.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    return number.replaceAllMapped(
        RegExp(r'.{4}'), (match) => '${match.group(0)} ');
  }

  String _formatMonthYear(String fecha) {
    if (fecha.isEmpty || !fecha.contains('/')) return 'MM/YYYY';

    List<String> parts = fecha.split('/');
    if (parts.length < 2) return 'MM/YYYY';

    // The format should be MM/YYYY
    String year = parts[0];
    String month = parts[1].padLeft(2, '0');

    // If year is 4 digits, take only the last 2
    if (year.length > 2) {
      year = year.substring(year.length - 2);
    }

    return '$month/$year';
  }
}
