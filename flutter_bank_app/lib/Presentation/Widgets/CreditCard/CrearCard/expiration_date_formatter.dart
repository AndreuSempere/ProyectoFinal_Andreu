import 'package:flutter/services.dart';

class ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text =
        newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Solo números

    if (text.length > 6) text = text.substring(0, 6); // Limita a MMYYYY

    String formattedText = '';
    if (text.length >= 3) {
      formattedText = '${text.substring(0, 2)}/${text.substring(2)}'; // MM/YYYY
    } else {
      formattedText = text;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
