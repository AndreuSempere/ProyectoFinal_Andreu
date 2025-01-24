import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Valida el DNI español
bool _isValidDNIES(String dni) {
  const String validLetters = "TRWAGMYFPDXBNJZSQVHLCKE";

  // Asegúrate de que tenga 8 números seguidos de una letra
  RegExp dniRegExp = RegExp(r'^(\d{8})([A-Z])$');
  Match? match = dniRegExp.firstMatch(dni);

  if (match != null) {
    String numberPart = match.group(1)!; // Los 8 dígitos
    String letterPart = match.group(2)!; // La letra

    // Calcular la letra esperada
    int number = int.parse(numberPart);
    String expectedLetter = validLetters[number % 23];

    return letterPart == expectedLetter;
  }
  return false;
}

/// Limpia y estandariza el texto para validar el DNI
String _sanitizeDNIES(String text) {
  return text
      .replaceAll('O', '0') // Cambia "O" (letra) por "0"
      .replaceAll('I', '1') // Cambia "I" (letra) por "1"
      .replaceAll('B', '8') // Cambia "B" (letra) por "8"
      .toUpperCase(); // Asegúrate de que todo esté en mayúsculas.
}

/// Extrae y valida el DNI del texto
String _extractDNIInfo(String recognizedText) {
  RegExp dniRegExp = RegExp(r'\b\d{8}[A-Z]\b');
  Match? match = dniRegExp.firstMatch(_sanitizeDNIES(recognizedText));

  if (match != null) {
    String dni = match.group(0) ?? '';
    return _isValidDNIES(dni) ? dni : 'DNI inválido';
  }
  return 'No se encontró un DNI válido';
}

/// Extrae la fecha de nacimiento del texto
String _extractDateOfBirth(String recognizedText) {
  // Dividimos el texto por líneas
  List<String> lines = recognizedText.split('\n');

  for (int i = 0; i < lines.length; i++) {
    // Verificamos si la línea actual contiene "Nacimiento" o "Naiximent"
    if (lines[i]
        .contains(RegExp(r'Nacimiento|Naiximent', caseSensitive: false))) {
      // Si existe una línea siguiente, buscamos la fecha allí
      if (i + 1 < lines.length) {
        String possibleDateLine = lines[i + 1];

        // Expresión regular para capturar formato de fecha DD MM AAAA
        RegExp dateRegExp = RegExp(r'(\d{2})\s*(\d{2})\s*(\d{4})');
        Match? match = dateRegExp.firstMatch(possibleDateLine);

        if (match != null) {
          // Extraemos y formateamos la fecha
          String day = match.group(1)!;
          String month = match.group(2)!;
          String year = match.group(3)!;
          return '$day/$month/$year'; // Formato DD/MM/AAAA
        }
      }
    }
  }

  return 'No se encontró una fecha de nacimiento válida';
}

/// Procesa la imagen y extrae texto usando OCR
Future<Map<String, String>> extractDNIData(String imagePath) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final image = InputImage.fromFile(File(imagePath));
  final recognized = await textRecognizer.processImage(image);

  // Extraer información del DNI
  final dniInfo = _extractDNIInfo(recognized.text);

  // Extraer la fecha de nacimiento
  final birthDate = _extractDateOfBirth(recognized.text);

  return {
    'dni': dniInfo,
    'birthDate': birthDate,
  };
}
