import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bank_app/Data/Models/user_model.dart';
import 'package:flutter_bank_app/core/failure.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth auth;
  FirebaseFirestore database = FirebaseFirestore.instance;

  FirebaseAuthDataSource({required this.auth});

  Future<UserModel> signUp(String email, String password) async {
    try {
      UserCredential userCredentials =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromUserCredential(userCredentials);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          throw AuthFailure(message: 'El correo ya está en uso.');
        } else if (e.code == 'weak-password') {
          throw AuthFailure(message: 'La contraseña es demasiado débil.');
        }
      }
      throw AuthFailure(message: 'Error al registrar al usuario.');
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    UserCredential userCredentials =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return UserModel.fromUserCredential(userCredentials);
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  String? getCurrentUser() {
    final user = auth.currentUser;
    return user?.email;
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          throw AuthFailure(
              message: 'No se encontró un usuario con ese correo.');
        }
      }
      throw AuthFailure(
          message: 'Error al enviar el correo de restablecimiento.');
    }
  }

  Future<void> newUser(String name, String surname, String email,
      String password, String dni, String age) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.26:8080/Users'),
        headers: {'Content-Type': 'application/json'},
        body: '''
        {
          "name": "$name",
          "surname": "$surname",
          "email": "$email",
          "password": "$password",
          "dni": "$dni",
          "age": "$age"
        }
        ''',
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Error al crear usuario en el backend: ${response.body}');
      }
    } catch (e) {
      throw Exception("Error al crear el usuario: $e");
    }
  }

  Future<UserModel> getUserInfo(String email) async {
    final response = await http
        .get(Uri.parse('http://192.168.18.26:8080/users/user/$email'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> userJson = json.decode(response.body);
      return UserModel.fromJson(userJson);
    } else {
      throw Exception('Error al cargar la cuenta del usuario');
    }
  }

  Future<void> updateUser(int idUser, String name, String surname, String email,
      String dni, String age) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.18.26:8080/Users/$idUser'),
        headers: {'Content-Type': 'application/json'},
        body: '''
        {
          "name": "$name",
          "surname": "$surname",
          "email": "$email",
          "dni": "$dni",
          "age": "$age"
        }
        ''',
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Error al editar usuario en el backend: ${response.body}');
      }
    } catch (e) {
      throw Exception("Error al actualizar el usuario: $e");
    }
  }
}
