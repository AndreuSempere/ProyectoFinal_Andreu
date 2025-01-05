class Account {
  final int? idCuenta;
  final String? numeroCuenta;
  final double? saldo;
  final String? estado;
  final DateTime? createdAt;
  final int accountType;
  final int idUser;

  Account(
      {this.idCuenta,
      this.numeroCuenta,
      this.saldo,
      this.estado,
      this.createdAt,
      required this.accountType,
      required this.idUser});
}
