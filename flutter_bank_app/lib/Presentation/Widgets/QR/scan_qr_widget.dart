import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class ScanQrPage extends StatefulWidget {
  @override
  _ScanQrPageState createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final GlobalKey<QrCodeScannerState> qrKey = GlobalKey<QrCodeScannerState>();
  String? scannedAccountId;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _onQRViewCreated(QrCodeScannerController controller) {
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedAccountId = scanData.code; 
      });
      _showTransactionForm(scanData.code);
    });
  }

  void _showTransactionForm(String accountId) {
    showDialog(
      context: context,
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
                String amount = _amountController.text;
                String description = _descriptionController.text;
                if (amount.isNotEmpty && description.isNotEmpty) {
                  _submitTransaction(amount, description, accountId);
                }
                Navigator.pop(context);
              },
              child: Text('Enviar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _submitTransaction(String amount, String description, String accountId) {
    print("Transacción a $accountId");
    print("Cantidad: $amount");
    print("Descripción: $description");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leer QR")),
      body: QrCodeScanner(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
