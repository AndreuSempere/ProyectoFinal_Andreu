import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:intl/intl.dart';

class TransactionModel {
  final int? id_transaction;
  final int cantidad;
  final String tipo;
  final String? descripcion;
  final int account;
  final int? targetAccount;
  final String? created_at;
  final String? receipt_url;

  TransactionModel({
    this.id_transaction,
    required this.cantidad,
    required this.tipo,
    this.descripcion,
    required this.account,
    this.targetAccount,
    this.created_at,
    this.receipt_url,
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
      id_transaction: json['id_transaction'],
      cantidad: json['cantidad'],
      tipo: json['tipo'],
      descripcion: json['descripcion'],
      account: json['account']?['id_cuenta'],
      targetAccount: json['targetAccount'],
      created_at: formattedDate,
      receipt_url: json['receipt_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_transaction': id_transaction,
      'cantidad': cantidad,
      'tipo': tipo,
      'descripcion': descripcion,
      'accountId': account,
      'targetAccountId': targetAccount,
      'created_at': created_at,
      'receipt_url': receipt_url,
    };
  }

  Transaction toEntity() {
    return Transaction(
      id_transaction: id_transaction,
      cantidad: cantidad,
      tipo: tipo,
      descripcion: descripcion,
      account: account,
      targetAccount: targetAccount,
      created_at: created_at,
      receipt_url: receipt_url,
    );
  }
}
