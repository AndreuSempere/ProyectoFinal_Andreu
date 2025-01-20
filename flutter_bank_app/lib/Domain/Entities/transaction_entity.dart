class Transaction {
  final int cantidad;
  final String tipo;
  final String? descripcion;
  final int account;
  final int? targetAccount;
  final String? created_at;

  Transaction({
    required this.cantidad,
    required this.tipo,
    this.descripcion,
    required this.account,
    this.targetAccount,
    this.created_at,
  });
}
