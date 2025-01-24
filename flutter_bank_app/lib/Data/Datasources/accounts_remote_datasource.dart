import 'dart:convert';
import 'package:flutter_bank_app/Data/Models/account_model.dart';
import 'package:http/http.dart' as http;

abstract class AccountRemoteDataSource {
  Future<List<AccountModel>> getAccounts(int id);
  Future<bool> createdAccount(AccountModel account);
  Future<void> deleteAccount(int id);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final http.Client client;

  AccountRemoteDataSourceImpl(this.client);

  @override
  Future<List<AccountModel>> getAccounts(int id) async {
    final response =
        await http.get(Uri.parse('http://172.20.10.8:8080/accounts/user/$id'));
    if (response.statusCode == 200) {
      final List<dynamic> accountsJson = json.decode(response.body);
      return accountsJson.map((json) => AccountModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar accounts');
    }
  }

  @override
  Future<bool> createdAccount(AccountModel account) async {
    final response = await http.post(
      Uri.parse('http://172.20.10.8:8080/accounts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(account.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          'Error al crear una account en el backend: ${response.body}');
    }
  }

  @override
  Future<void> deleteAccount(int id) async {
    final response = await client.delete(
      Uri.parse('http://172.20.10.8:8080/accounts/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al borrar la account');
    }
  }
}
