import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';
import 'package:intl/intl.dart';

class AccountModel {
  final int? idCuenta;
  final String? numero_cuenta;
  final double? saldo;
  final String? estado;
  final String? fecCreacion;
  final int accounts_type;
  final int id_user;
  final String description;
  final String? icon;

  AccountModel({
    this.idCuenta,
    required this.numero_cuenta,
    this.saldo,
    this.estado,
    this.fecCreacion,
    required this.accounts_type,
    required this.id_user,
    required this.description,
    this.icon,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    String? formattedDate;
    if (json['fecha_creacion'] != null) {
      try {
        final parsedDate = DateTime.parse(json['fecha_creacion']);
        formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (e) {
        formattedDate = null;
      }
    }

    return AccountModel(
      idCuenta: json['id_cuenta'],
      numero_cuenta: json['numero_cuenta'],
      saldo: json['saldo'],
      estado: json['estado'],
      fecCreacion: formattedDate,
      accounts_type: json['accounts_type']?['id_type'],
      id_user: json['id_user']?['id_user'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCuenta': idCuenta,
      'numero_cuenta': numero_cuenta,
      'saldo': saldo,
      'estado': estado,
      'fecCreacion': fecCreacion,
      'accounts_type': accounts_type,
      'id_user': id_user,
      'description': description,
      'icon': icon,
    };
  }

  Account toEntity() {
    return Account(
      idCuenta: idCuenta,
      numeroCuenta: numero_cuenta,
      saldo: saldo,
      createdAt: fecCreacion,
      accountType: accounts_type,
      idUser: id_user,
      description: description,
      icon: icon,
    );
  }
}
