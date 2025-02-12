import 'package:flutter_bank_app/Domain/Entities/card_entity.dart';
import 'package:intl/intl.dart';

class CardModel {
  final int? id_tarjeta;
  final String cardHolderName;
  final String numero_tarjeta;
  final String tipo_tarjeta;
  final String? fecha_expiracion;
  final int? cvv; // Cambiar a int? para permitir null
  final int? color; // Cambiar a int? para permitir null
  final int? id_cuenta; // Cambiar a int? para permitir null

  CardModel({
    this.id_tarjeta,
    required this.cardHolderName,
    required this.numero_tarjeta,
    required this.tipo_tarjeta,
    this.fecha_expiracion,
    this.cvv, // Cambiar a tipo nullable
    this.color, // Cambiar a tipo nullable
    this.id_cuenta, // Cambiar a tipo nullable
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    String? formattedDate;
    if (json['fecha_expiracion'] != null) {
      try {
        final parsedDate = DateTime.parse(json['fecha_expiracion']);
        formattedDate = DateFormat('MM/yyyy').format(parsedDate);
      } catch (e) {
        formattedDate = null;
      }
    }

    return CardModel(
      id_tarjeta: json['id_tarjeta'],
      cardHolderName: json['cardHolderName'],
      numero_tarjeta: json['numero_tarjeta'],
      tipo_tarjeta: json['tipo_tarjeta'],
      fecha_expiracion: formattedDate,
      cvv: json['cvv'], // No es necesario hacer cast, ya que puede ser null
      color: json['color'], // Puede ser null
      id_cuenta: json['id_cuenta'], // Puede ser null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_tarjeta': id_tarjeta,
      'cardHolderName': cardHolderName,
      'numero_tarjeta': numero_tarjeta,
      'tipo_tarjeta': tipo_tarjeta,
      'fecha_expiracion': fecha_expiracion,
      'cvv': cvv,
      'color': color,
      'id_cuenta': id_cuenta,
    };
  }

  CreditCardEntity toEntity() {
    return CreditCardEntity(
      id_tarjeta: id_tarjeta,
      cardHolderName: cardHolderName,
      numero_tarjeta: numero_tarjeta,
      tipo_tarjeta: tipo_tarjeta,
      fecha_expiracion: fecha_expiracion,
      cardCvv: cvv,
      cardColor: color,
      id_cuenta: id_cuenta,
    );
  }
}

class CardColorModel {
  bool isSelected;
  final int colorIndex;
  CardColorModel({required this.isSelected, required this.colorIndex});
}
