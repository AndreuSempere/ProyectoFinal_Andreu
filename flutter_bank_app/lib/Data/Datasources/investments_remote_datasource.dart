import 'dart:convert';
import 'package:flutter_bank_app/Data/Models/investments_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class InvestmentRemoteDataSource {
  Future<List<InvestmentModel>> getInvestments(int accountid);
  Future<bool> createdInvestment(InvestmentModel investments);
}

class InvestmentsRemoteDatasourceImpl implements InvestmentRemoteDataSource {
  final http.Client client;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final String investmentsPath = dotenv.env['API_INVESTMENTS_PATH'] ?? '';

  InvestmentsRemoteDatasourceImpl(this.client);

  @override
  Future<List<InvestmentModel>> getInvestments(int accountid) async {
    try {
      final uri = Uri.parse('$baseUrl$investmentsPath?accountId=$accountid');
      final response = await client.get(uri);

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
  Future<bool> createdInvestment(InvestmentModel investments) async {
    try {
      final uri = Uri.parse('$baseUrl$investmentsPath');
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(investments.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Error al crear una cuenta en el backend: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al crear la cuenta: $e');
    }
  }
}
