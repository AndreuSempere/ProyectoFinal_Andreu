import 'package:flutter_bank_app/Domain/Entities/investment_entity.dart';
import 'package:intl/intl.dart';

class InvestmentModel {
  final int? idInvestment;
  final int? idAccount;
  final double? amount;
  final double? purchase_price;
  final double? current_value;
  final int tradingId;
  final String? purchase_date;
  final String? last_updated;

  InvestmentModel({
    this.idInvestment,
    this.idAccount,
    this.amount,
    this.purchase_price,
    this.current_value,
    required this.tradingId,
    required this.purchase_date,
    required this.last_updated,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    String? purchase_date;
    if (json['purchase_date'] != null) {
      try {
        final parsedDate = DateTime.parse(json['purchase_date']);
        purchase_date = DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (e) {
        purchase_date = null;
      }
    }
    String? last_updated;
    if (json['last_updated'] != null) {
      try {
        final parsedDate = DateTime.parse(json['last_updated']);
        last_updated = DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (e) {
        last_updated = null;
      }
    }

    return InvestmentModel(
      idInvestment: json['idInvestment'] ?? 0,
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
      purchase_price: json['purchase_price'] != null
          ? double.tryParse(json['purchase_price'].toString())
          : null,
      current_value: json['current_value'] != null
          ? double.tryParse(json['current_value'].toString())
          : null,
      purchase_date: purchase_date,
      idAccount: json['account']?['id_cuenta'] ?? 0,
      tradingId: json['trading']?['idtrading'] ?? 0,
      last_updated: last_updated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idInvestment': idInvestment,
      'idAccount': idAccount,
      'amount': amount,
      'purchase_price': purchase_price,
      'current_value': current_value,
      'tradingId': tradingId,
      'purchase_date': purchase_date,
      'last_updated': last_updated,
    };
  }

  InvestmentEntity toEntity() {
    return InvestmentEntity(
      idInvestment: idInvestment,
      idAccount: idAccount,
      amount: amount,
      purchase_price: purchase_price,
      current_value: current_value,
      tradingId: tradingId,
      purchase_date: purchase_date,
      last_updated: last_updated,
    );
  }
}
