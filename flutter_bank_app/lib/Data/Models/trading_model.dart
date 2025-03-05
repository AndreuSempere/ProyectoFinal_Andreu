import 'package:flutter_bank_app/Domain/Entities/trading_entity.dart';

class TradingModel {
  final int? idTrading;
  final String? type;
  final String? name;
  final String? symbol;
  final double? price;
  final DateTime? recordedAt;

  TradingModel({
    this.idTrading,
    this.type,
    this.name,
    this.symbol,
    this.price,
    this.recordedAt,
  });

  factory TradingModel.fromJson(Map<String, dynamic> json) {
    return TradingModel(
      idTrading: json['id'],
      type: json['type'],
      name: json['name'],
      symbol: json['symbol'],
      price: double.tryParse(json['price'].toString()),
      recordedAt: json['recordedAt'] != null
          ? DateTime.tryParse(json['recordedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idTrading,
      'type': type,
      'name': name,
      'symbol': symbol,
      'price': price?.toString(),
      'recordedAt': recordedAt?.toIso8601String(),
    };
  }

  TradingEntity toEntity() {
    return TradingEntity(
      id: idTrading,
      type: type,
      name: name,
      symbol: symbol,
      price: price,
      recordedAt: recordedAt,
    );
  }
}
