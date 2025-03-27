import 'dart:convert';
import 'package:flutter_bank_app/Data/Models/trading_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TradingRemoteDataSource {
  Future<List<TradingModel>> getAllTrading();
  Future<List<TradingModel>> getTradingRecord(String name);
}

class TradingRemoteDataSourceImpl implements TradingRemoteDataSource {
  final http.Client client;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final String tradingPath = dotenv.env['API_TRADING_PATH'] ?? '';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  TradingRemoteDataSourceImpl(this.client);

  Future<String?> getBearerToken() async {
    return await secureStorage.read(key: 'user_token');
  }

  @override
  Future<List<TradingModel>> getAllTrading() async {
    try {
      final uri = Uri.parse('$baseUrl$tradingPath/');
      final token = await getBearerToken();

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> tradingJson = json.decode(response.body);
        return tradingJson.map((json) => TradingModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Error al cargar los valores de bolsa: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al obtener los valores de bolsa: $e');
    }
  }

  @override
  Future<List<TradingModel>> getTradingRecord(String name) async {
    try {
      final uri = Uri.parse('$baseUrl$tradingPath/$name');
      final token = await getBearerToken();

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> tradingJson = json.decode(response.body);
        return tradingJson.map((json) => TradingModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Error al cargar los datos del record: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al obtener los datos del record: $e');
    }
  }
}
