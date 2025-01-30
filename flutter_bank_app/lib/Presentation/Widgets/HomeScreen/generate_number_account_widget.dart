import 'dart:math';

class GenerateAccountNumber {
  static String generate() {
    final random = Random();
    return List.generate(16, (_) => random.nextInt(10).toString()).join();
  }
}
