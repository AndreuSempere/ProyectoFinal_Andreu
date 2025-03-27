import 'dart:convert';
import 'package:flutter_bank_app/Data/Models/account_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AccountRemoteDataSource {
  Future<List<AccountModel>> getAccounts(int id);
  Future<bool> createdAccount(AccountModel account);
  Future<void> deleteAccount(int id);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final http.Client client;
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final String accountsPath = dotenv.env['API_ACCOUNTS_PATH'] ?? '';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AccountRemoteDataSourceImpl(this.client);

  Future<String?> getBearerToken() async {
    return await secureStorage.read(key: 'user_token');
  }

  @override
  Future<List<AccountModel>> getAccounts(int id) async {
    try {
      final uri = Uri.parse('$baseUrl$accountsPath/user/$id');
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
        return accountsJson.map((json) => AccountModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las cuentas: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al obtener las cuentas: $e');
    }
  }

  @override
  Future<bool> createdAccount(AccountModel account) async {
    try {
      final uri = Uri.parse('$baseUrl$accountsPath');
      final token = await getBearerToken();

      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(account.toJson()),
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

  @override
  Future<void> deleteAccount(int id) async {
    try {
      final uri = Uri.parse('$baseUrl$accountsPath/$id');
      final token = await getBearerToken();

      final response = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al borrar la cuenta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al borrar la cuenta: $e');
    }
  }
}
