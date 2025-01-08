class Transaction {
  final int? id_transaction;
  final int cantidad;
  final String tipo;
  final String? descripcion;
  final int account;
  final String? created_at;

  Transaction({
    this.id_transaction,
    required this.cantidad,
    required this.tipo,
    this.descripcion,
    required this.account,
    this.created_at,
  });
}
