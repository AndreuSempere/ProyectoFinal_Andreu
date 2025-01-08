class Transaction {
  final int cantidad;
  final String tipo;
  final String? descripcion;
  final int account;
  final String? created_at;

  Transaction({
    required this.cantidad,
    required this.tipo,
    this.descripcion,
    required this.account,
    this.created_at,
  });
}
