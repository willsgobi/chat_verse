import 'dart:math';

class StringGenerator {
  static String generateRandomString() {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    final random = Random();

    String result = '';

    for (var i = 0; i < 10; i++) {
      final index = random.nextInt(characters.length);
      result += characters[index];
    }

    return result;
  }
}
