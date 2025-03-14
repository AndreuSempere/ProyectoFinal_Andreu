import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrPage extends StatelessWidget {
  final int accountId;

  const GenerateQrPage({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generar QR")),
      body: Center(
        child: QrImageView(
          data: accountId.toString(),
          size: 200.0,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
