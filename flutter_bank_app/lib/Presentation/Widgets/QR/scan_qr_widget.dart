import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  _ScanQrPageState createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
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
      _showTransactionForm(scannedAccountId);
    }
  }

  void _showTransactionForm(String? accountId) {
    if (accountId == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Transacción a $accountId"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String amount = _amountController.text.trim();
                String description = _descriptionController.text.trim();
                if (amount.isNotEmpty && description.isNotEmpty) {
                  _submitTransaction(amount, description, accountId);
                  Navigator.pop(context);
                }
              },
              child: Text('Enviar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => isProcessing = false);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() => isProcessing = false);
    });
  }

  void _submitTransaction(String amount, String description, String accountId) {
    print("Transacción a $accountId");
    print("Cantidad: $amount");
    print("Descripción: $description");
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leer QR")),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              onDetect: _onDetect,
            ),
          ),
        ],
      ),
    );
  }
}
