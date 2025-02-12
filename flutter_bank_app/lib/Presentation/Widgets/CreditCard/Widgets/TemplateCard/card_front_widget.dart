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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// **Fila superior con el chip y logo de la tarjeta**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const CardChip(),
              Image.asset(
                'assets/credit_card/visa_logo.png',
                width: 65.0,
                height: 32.0,
              ),
            ],
          ),

          const SizedBox(height: 20.0),

          /// **Número de tarjeta**
          Text(
            _formatCardNumber(card.numero_tarjeta),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// **Nombre del titular**
              Expanded(
                child: Text(
                  card.cardHolderName.isNotEmpty
                      ? card.cardHolderName.toUpperCase()
                      : 'CARDHOLDER NAME',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              /// **Fecha de vencimiento**
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'VALID THRU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.0,
                      ),
                    ),
                    Text(
                      _formatMonthYear(card.fecha_expiracion!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
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

    String month = parts[0].padLeft(2, '0');
    String year = parts[1];

    return '$month/$year';
  }
}
