class TradingEntity {
  final int? id;
  final String? type;
  final String? name;
  final String? symbol;
  final double? price;
  final DateTime? recordedAt;

  TradingEntity(
      {this.id,
      this.type,
      this.name,
      this.symbol,
      this.price,
      this.recordedAt});
}
