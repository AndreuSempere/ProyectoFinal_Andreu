import 'dart:convert';
import 'package:flutter_bank_app/Data/Models/investments_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class InvestmentRemoteDataSource {
  Future<List<InvestmentModel>> getInvestments(int accountid);
  Future<bool> createdInvestment(String symbol, double amount, int accountId);
}

class InvestmentsRemoteDatasourceImpl implements InvestmentRemoteDataSource {
  final http.Client client;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final String investmentsPath = dotenv.env['API_INVESTMENTS_PATH'] ?? '';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  InvestmentsRemoteDatasourceImpl(this.client);

  Future<String?> getBearerToken() async {
    return await secureStorage.read(key: 'user_token');
  }

  @override
  Future<List<InvestmentModel>> getInvestments(int accountid) async {
    try {
      final uri = Uri.parse('$baseUrl$investmentsPath?accountId=$accountid');
      final token = await getBearerToken();

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> accountsJson = json.decode(response.body);
        return accountsJson
            .map((json) => InvestmentModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Error al cargar las cuentas: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al obtener las cuentas: $e');
    }
  }

  @override
  Future<bool> createdInvestment(
      String symbol, double amount, int accountId) async {
    try {
      final uri = Uri.parse('$baseUrl$investmentsPath');
      final token = await getBearerToken();

      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'account_id': accountId,
          'symbol': symbol,
          'amount': amount,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Error al crear la inversión en el backend: ${response.body}');
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Fallo al crear la inversión: $e');
    }
  }
}
