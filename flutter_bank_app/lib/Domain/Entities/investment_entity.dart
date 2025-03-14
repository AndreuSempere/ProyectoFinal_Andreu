class InvestmentEntity {
  final int? idInvestment;
  final int? idAccount;
  final double? amount;
  final double? purchase_price;
  final double? current_value;
  final int tradingId;
  final String? purchase_date;
  final String? last_updated;

  InvestmentEntity({
    this.idInvestment,
    this.idAccount,
    this.amount,
    this.purchase_price,
    this.current_value,
    required this.tradingId,
    required this.purchase_date,
    required this.last_updated,
  });
}
