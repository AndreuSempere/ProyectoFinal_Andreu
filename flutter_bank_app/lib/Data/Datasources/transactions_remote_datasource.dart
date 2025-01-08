import 'dart:convert';
import 'package:flutter_bank_app/Data/Models/transaction_model.dart';
import 'package:http/http.dart' as http;

abstract class TransactionsRemoteDataSource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<bool> createdTransactions(TransactionModel transaction);
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final http.Client client;

  TransactionsRemoteDataSourceImpl(this.client);

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/transactions'));
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
      Uri.parse('http://localhost:8080/transactions'),
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
}
