import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:crypto/crypto.dart';

class PasswordHashProvider {
  static String generatePassword(String password, String salt) {
    try {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);

      String decodedSalt = stringToBase64.decode(salt);

      String input = decodedSalt + password;

      List<int> byteInput = utf8.encode(input);
      List<int> byteHash = sha256.convert(byteInput).bytes;

      String hash = base64.encode(byteHash);

      return '5\$' + salt + '\$' + hash;
    } catch (e) {
      throw Exception('errors.loginException'.tr());
    }
  }
}
