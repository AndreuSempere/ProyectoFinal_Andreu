import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:intl/intl.dart';

class TransactionModel {
  final int cantidad;
  final String tipo;
  final String? descripcion;
  final int account;
  final String? created_at;

  TransactionModel({
    required this.cantidad,
    required this.tipo,
    this.descripcion,
    required this.account,
    this.created_at,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    String? formattedDate;
    if (json['created_at'] != null) {
      try {
        final parsedDate = DateTime.parse(json['created_at']);
        formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (e) {
        formattedDate = null;
      }
    }

    return TransactionModel(
      cantidad: json['cantidad'],
      tipo: json['tipo'],
      descripcion: json['descripcion'],
      account: json['account']?['id_cuenta'],
      created_at: formattedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cantidad': cantidad,
      'tipo': tipo,
      'descripcion': descripcion,
      'accountId': account,
    };
  }

  Transaction toEntity() {
    return Transaction(
      cantidad: cantidad,
      tipo: tipo,
      descripcion: descripcion,
      account: account,
      created_at: created_at,
    );
  }
}
