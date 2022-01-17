import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

String generateSalt([int length = 32]) {
  var rand = Random.secure();

  var saltBytes = List.generate(
    length,
    (_) => rand.nextInt(256),
  );

  return base64Encode(saltBytes);
}

String hashPassword(String password, String salt) {
  List<int> encodedPassword = utf8.encode(password);

  List<int> encodedSalt = utf8.encode(salt);

  var hmac = Hmac(sha256, encodedSalt);

  return hmac.convert(encodedPassword).toString();
}
