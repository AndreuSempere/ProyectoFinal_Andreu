class CreditCardEntity {
  final int? id_tarjeta;
  final String cardHolderName;
  final String numero_tarjeta;
  final String tipo_tarjeta;
  final String? fecha_expiracion;
  final int? cardCvv;
  final int? cardColor;
  final int? id_cuenta;

  CreditCardEntity({
    this.id_tarjeta,
    required this.cardHolderName,
    required this.numero_tarjeta,
    required this.tipo_tarjeta,
    this.fecha_expiracion,
    this.cardCvv,
    this.cardColor,
    this.id_cuenta,
  });

  CreditCardEntity copyWith({
    int? id_tarjeta,
    String? cardHolderName,
    String? numero_tarjeta,
    String? tipo_tarjeta,
    String? fecha_expiracion,
    int? cardCvv,
    int? cardColor,
    int? id_cuenta,
  }) {
    return CreditCardEntity(
      id_tarjeta: id_tarjeta ?? this.id_tarjeta,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      numero_tarjeta: numero_tarjeta ?? this.numero_tarjeta,
      tipo_tarjeta: tipo_tarjeta ?? this.tipo_tarjeta,
      fecha_expiracion: fecha_expiracion ?? this.fecha_expiracion,
      cardCvv: cardCvv ?? this.cardCvv,
      cardColor: cardColor ?? this.cardColor,
      id_cuenta: id_cuenta ?? this.id_cuenta,
    );
  }
}
