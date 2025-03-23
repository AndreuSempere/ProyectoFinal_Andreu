import 'package:flutter/material.dart';
import 'package:flutter_bank_app/Domain/Entities/transaction_entity.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_bloc.dart';
import 'package:flutter_bank_app/Presentation/Blocs/transactions/transaction_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrPage extends StatefulWidget {
  final int accountId;

  const ScanQrPage({super.key, required this.accountId});

  @override
  _ScanQrPageState createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  String? scannedAccountId;
  bool isProcessing = false;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _onDetect(BarcodeCapture capture) {
    if (!isProcessing && capture.barcodes.isNotEmpty) {
      setState(() {
        isProcessing = true;
        scannedAccountId = capture.barcodes.first.rawValue;
      });

      _scannerController.stop();
      _showTransactionForm(scannedAccountId);
    }
  }

  void _showTransactionForm(String? targetAccountId) {
    if (targetAccountId == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Transacción"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => isProcessing = false);
                _scannerController.start();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String amount = _amountController.text.trim();
                String description = _descriptionController.text.trim();
                if (amount.isNotEmpty && description.isNotEmpty) {
                  _submitTransaction(amount, description, targetAccountId);
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() => isProcessing = false);
      _scannerController.start();
    });
  }

  void _submitTransaction(
      String amount, String description, String targetAccountId) {
    final newTransaction = Transaction(
      account: widget.accountId,
      targetAccount: int.parse(targetAccountId),
      cantidad: int.parse(amount),
      descripcion: description,
      tipo: 'gasto',
    );

    context.read<TransactionBloc>().add(CreateTransactions(newTransaction));

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

    _scannerController.start();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leer QR")),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
            ),
          ),
        ],
      ),
    );
  }
}
