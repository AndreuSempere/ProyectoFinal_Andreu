import 'package:flutter_bank_app/Domain/Entities/account_entity.dart';

class AccountModel {
  final int? idCuenta;
  final String? numero_cuenta;
  final double? saldo;
  final String? estado;
  final DateTime? fecCreacion;
  final int accounts_type;
  final int id_user;

  AccountModel({
    required this.idCuenta,
    required this.numero_cuenta,
    this.saldo,
    this.estado,
    this.fecCreacion,
    required this.accounts_type,
    required this.id_user,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      idCuenta: json['id_cuenta'],
      numero_cuenta: json['numero_cuenta'],
      saldo: json['saldo'],
      estado: json['estado'],
      fecCreacion: json['fecha_creacion'],
      accounts_type: json['accounts_type']?['id_type'],
      id_user: json['id_user']?['id_user'],
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
    );
  }
}
