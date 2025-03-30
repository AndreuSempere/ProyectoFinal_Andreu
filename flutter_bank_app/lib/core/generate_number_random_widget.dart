import 'dart:math';

class GenerateAccountNumber {
  static String generate() {
    final random = Random();

    // Generar código de entidad bancaria
    final bankCode =
        List.generate(4, (_) => random.nextInt(10).toString()).join();

    // Generar código de oficina
    final branchCode =
        List.generate(2, (_) => random.nextInt(10).toString()).join();

    // Generar dígito de control
    final controlDigits =
        List.generate(4, (_) => random.nextInt(10).toString()).join();

    // Generar número de cuenta
    final accountNumber =
        List.generate(10, (_) => random.nextInt(10).toString()).join();

    // Crear el número de cuenta bancaria español
    final spanishAccountNumber =
        bankCode + branchCode + controlDigits + accountNumber;

    // Calcular los dígitos de control del IBAN
    final ibanControlDigits =
        _calculateIBANControlDigits("ES00$spanishAccountNumber");

    // Formato final: ES + dígitos de control + número de cuenta bancaria
    return "ES$ibanControlDigits$spanishAccountNumber";
  }

  // Método para calcular los dígitos de control del IBAN
  static String _calculateIBANControlDigits(String iban) {
    // Mover los primeros 4 caracteres al final: "ES00" + cuenta -> cuenta + "ES00"
    final rearranged = iban.substring(4) + iban.substring(0, 4);

    // Convertir letras a números según el estándar IBAN (E=14, S=28)
    String numeric = "";
    for (int i = 0; i < rearranged.length; i++) {
      final char = rearranged[i];
      if (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) {
        numeric += (char.codeUnitAt(0) - 55).toString();
      } else {
        numeric += char;
      }
    }

    // Calcular el módulo 97 y obtener los dígitos de control
    BigInt number = BigInt.parse(numeric);
    BigInt mod97 = number % BigInt.from(97);
    int checkDigits = 98 - mod97.toInt();

    // Asegurar que los dígitos de control tengan dos posiciones
    return checkDigits < 10 ? "0$checkDigits" : "$checkDigits";
  }
}

class GenerateCreditCardNumber {
  static String generate() {
    final random = Random();
    return List.generate(16, (_) => random.nextInt(10).toString()).join();
  }
}
