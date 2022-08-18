import 'dart:convert';
import 'package:crypto/crypto.dart';

class MD5Util {
  /// md5 摘要算法
  static String generateMd5(String data) {
    return md5.convert(utf8.encode(data)).toString();
  }
}
