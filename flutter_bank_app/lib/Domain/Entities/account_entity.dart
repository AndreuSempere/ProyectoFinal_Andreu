class Account {
  final int? idCuenta;
  final String? numeroCuenta;
  final int? saldo;
  final String? estado;
  final String? createdAt;
  final int accountType;
  final int idUser;
  final String description;
  final String? icon;

  Account(
      {this.idCuenta,
      this.numeroCuenta,
      this.saldo,
      this.estado,
      this.createdAt,
      required this.accountType,
      required this.idUser,
      required this.description,
      this.icon});
}
