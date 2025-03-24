class Transaction {
  final int? id_transaction;
  final int cantidad;
  final String tipo;
  final String? descripcion;
  final int account;
  final int? targetAccount;
  final String? created_at;
  final String? receipt_url;

  Transaction({
    this.id_transaction,
    required this.cantidad,
    required this.tipo,
    this.descripcion,
    required this.account,
    this.targetAccount,
    this.created_at,
    this.receipt_url,
  });
}
