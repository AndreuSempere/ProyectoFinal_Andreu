import 'dart:convert';
import 'package:flutter_bank_app/Data/Models/credit_card_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class CreditCardRemoteDataSource {
  Future<List<CardModel>> getAllCreditCards();
  Future<CardModel> getCreditCardById(int id);
  Future<CardModel> getCreditCardByNumber(int number);
  Future<bool> createCreditCard(CardModel card);
  Future<bool> updateCreditCard(int id, CardModel card);
  Future<void> deleteCreditCard(int id);
}

class CreditCardRemoteDataSourceImpl implements CreditCardRemoteDataSource {
  final http.Client client;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final String creditCardPath = dotenv.env['API_CREDIT_CARD_PATH'] ?? '';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  CreditCardRemoteDataSourceImpl(this.client);

  Future<String?> getBearerToken() async {
    return await secureStorage.read(key: 'user_token');
  }

  @override
  Future<List<CardModel>> getAllCreditCards() async {
    try {
      final uri = Uri.parse('$baseUrl$creditCardPath');
      final token = await getBearerToken();
      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> cardsJson = json.decode(response.body);
        return cardsJson.map((json) => CardModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las tarjetas: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al obtener las tarjetas: $e');
    }
  }

  @override
  Future<CardModel> getCreditCardById(int id) async {
    try {
      final uri = Uri.parse('$baseUrl$creditCardPath/id/$id');
      final token = await getBearerToken();

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return CardModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener la tarjeta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al obtener la tarjeta: $e');
    }
  }

  @override
  Future<CardModel> getCreditCardByNumber(int number) async {
    try {
      final uri = Uri.parse('$baseUrl$creditCardPath/num/$number');
      final token = await getBearerToken();

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return CardModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener la tarjeta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al obtener la tarjeta: $e');
    }
  }

  @override
  Future<bool> createCreditCard(CardModel card) async {
    try {
      final uri = Uri.parse('$baseUrl$creditCardPath');
      final token = await getBearerToken();

      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(card.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Fallo al crear la tarjeta: $e');
    }
  }

  @override
  Future<bool> updateCreditCard(int id, CardModel card) async {
    try {
      final uri = Uri.parse('$baseUrl$creditCardPath/$id');
      final token = await getBearerToken();
      final response = await client.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(card.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Fallo al actualizar la tarjeta: $e');
    }
  }

  @override
  Future<void> deleteCreditCard(int id) async {
    try {
      final uri = Uri.parse('$baseUrl$creditCardPath/$id');
      final token = await getBearerToken();

      final response = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar la tarjeta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al eliminar la tarjeta: $e');
    }
  }
}
