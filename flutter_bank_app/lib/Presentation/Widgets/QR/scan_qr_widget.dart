import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  _ScanQrPageState createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedAccountId;
  bool isProcessing = false;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isProcessing) {
        setState(() {
          isProcessing = true;
          scannedAccountId = scanData.code;
        });
        _showTransactionForm(scanData.code);
      }
    });
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
    controller?.dispose();
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
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }
}
