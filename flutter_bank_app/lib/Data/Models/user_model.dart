import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bank_app/Domain/Entities/user_entity.dart';

class UserModel {
  final int? id_user;
  final String email;
  final String name;
  final String surname;
  final String? dni;
  final String? age;
  final int? telf;

  UserModel({
    this.id_user,
    required this.email,
    required this.name,
    required this.surname,
    this.dni,
    this.age,
    this.telf,
  });

  static UserModel fromUserCredential(UserCredential userCredentials) {
    return UserModel(
      email: userCredentials.user?.email ?? "NO_EMAIL",
      name: "Default Name",
      surname: "Default Surname",
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id_user: json['id_user'] as int?,
      email: json['email'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      dni: json['dni'] as String?,
      age: json['age'] as String?,
      telf: json['telf'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'email': email,
      'name': name,
      'surname': surname,
      'dni': dni,
      'age': age,
      'telf': telf,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      idUser: id_user,
      name: name,
      surname: surname,
      email: email,
      dni: dni,
      age: age,
      telf: telf,
    );
  }
}
