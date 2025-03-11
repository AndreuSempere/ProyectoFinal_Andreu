import 'dart:convert';
import 'package:flutter_bank_app/Data/Models/transaction_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class TransactionsRemoteDataSource {
  Future<List<TransactionModel>> getAllTransactions(int id);
  Future<bool> createdTransactions(TransactionModel transaction);
  Future<bool> createdTransactionsBizum(TransactionModel transaction);
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final http.Client client;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final String transactionPath = dotenv.env['API_TRANSACTION_PATH'] ?? '';

  TransactionsRemoteDataSourceImpl(this.client);

  @override
  Future<List<TransactionModel>> getAllTransactions(int id) async {
    try {
      final uri = Uri.parse('$baseUrl$transactionPath/user/$id');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> transactionsJson = json.decode(response.body);
        return transactionsJson
            .map((json) => TransactionModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Error al cargar las transacciones: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al obtener las transacciones datasource: $e');
    }
  }

  @override
  Future<bool> createdTransactions(TransactionModel transaction) async {
    try {
      final uri = Uri.parse('$baseUrl$transactionPath');
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Error al crear una transacción en el backend: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al crear la transacción: $e');
    }
  }

  @override
  Future<bool> createdTransactionsBizum(TransactionModel transaction) async {
    try {
      final uri = Uri.parse('$baseUrl$transactionPath/bizum');
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Error al enviar el bizum: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al enviar el bizum: $e');
    }
  }
}
