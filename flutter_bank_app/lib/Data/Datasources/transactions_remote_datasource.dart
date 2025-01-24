import 'dart:convert';
import 'package:flutter_bank_app/Data/Models/transaction_model.dart';
import 'package:http/http.dart' as http;

abstract class TransactionsRemoteDataSource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<bool> createdTransactions(TransactionModel transaction);
  Future<bool> createdTransactionsBizum(TransactionModel transaction);
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final http.Client client;

  TransactionsRemoteDataSourceImpl(this.client);

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final response =
        await http.get(Uri.parse('http://172.20.10.8:8080/transaction'));
    if (response.statusCode == 200) {
      final List<dynamic> accountsJson = json.decode(response.body);
      return accountsJson
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar las transacciones');
    }
  }

  @override
  Future<bool> createdTransactions(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse('http://172.20.10.8:8080/transaction'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          'Error al crear una transacción en el backend: ${response.body}');
    }
  }

  @override
  Future<bool> createdTransactionsBizum(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse('http://172.20.10.8:8080/transaction/bizum'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al enviar el bizum: ${response.body}');
    }
  }
}
