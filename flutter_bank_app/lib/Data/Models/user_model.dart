import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bank_app/Domain/Entities/user_entity.dart';

class UserModel {
  final String email;
  final String name;
  final String surname;
  final String? dni;
  final String? age;

  UserModel({
    required this.email,
    required this.name,
    required this.surname,
    this.dni,
    this.age,
  });

  static UserModel fromUserCredential(UserCredential userCredentials) {
    return UserModel(
      email: userCredentials.user?.email ?? "NO_EMAIL",
      name: userCredentials.user?.email ?? "NO_NAME",
      surname: userCredentials.user?.email ?? "NO_SURNAME",
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      dni: json['dni'] as String?,
      age: json['age'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'dni': dni,
      'age': age,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      surname: surname,
      email: email,
      dni: dni,
      age: age,
    );
  }
}
