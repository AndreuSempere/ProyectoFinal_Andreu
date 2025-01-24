import 'dart:convert';
import 'package:flutter/services.dart';

class NFCService {
  final MethodChannel _javaChannel =
      const MethodChannel("com.example.flutter_bank_app");

  Future<int> checkNFCStatus() async {
    try {
      final int status = await _javaChannel.invokeMethod('init');
      return status; // 0: No disponible, 1: Activar NFC, 2: Listo
    } on PlatformException {
      return 0; // Error: NFC no disponible
    }
  }

  Future<Map<String, dynamic>> initCardScanListener() async {
    try {
      final scanResult = await _javaChannel.invokeMethod("listen");
      final scanOp = json.decode(scanResult);
      if (scanOp['success']) {
        String cardData = scanOp['cardData'];
        String cardNumber = extractCardNumber(cardData);
        return {'success': true, 'cardData': cardNumber}; // No enmascarado aquí
      } else {
        throw PlatformException(code: '01', stacktrace: scanOp['error']);
      }
    } on PlatformException catch (e) {
      return {'success': false, 'error': e.message};
    }
  }

  String extractCardNumber(String scanResult) {
    final RegExp regExp = RegExp(r"cardNumber=(\d+)");
    final match = regExp.firstMatch(scanResult);
    return match != null ? match.group(1) ?? "Unknown" : "Invalid Data";
  }

  String maskCardNumber(String cardNumber) {
    if (cardNumber.length > 4) {
      return cardNumber.replaceRange(
          0, cardNumber.length - 4, '*' * (cardNumber.length - 4));
    } else {
      return cardNumber;
    }
  }
}
