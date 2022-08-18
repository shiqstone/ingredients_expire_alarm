import 'dart:io';

import 'package:flutter/material.dart';

class Utils {
  static String getImgPath(String name, {String? format = 'png'}) {
    if (null == format || format.isEmpty) {
      format = 'png';
    }
    return 'assets/images/$name.$format';
  }

  static String getAvatarPath(String name, {String? format = 'png'}) {
    if (null == format || format.isEmpty) {
      format = 'png';
    }
    return 'assets/avatar/$name.$format';
  }

  static String getGifPath(String name) {
    return 'assets/gif/$name.gif';
  }

  static String getMapPath(String name, {String? format = 'png'}) {
    if (null == format || format.isEmpty) {
      format = 'png';
    }
    return 'assets/map/$name.$format';
  }

  static String getGamePath(String name, {String? format = 'png'}) {
    if (null == format || format.isEmpty) {
      format = 'png';
    }
    return 'assets/game/$name.$format';
  }

  //包含emoji的字符串截取
  static String maxLength(String str, int len) {
    // 删除emoji表情
    var sRunes = str.runes;
    return sRunes.length > len ? String.fromCharCodes(sRunes, 0, len) : str;
  }

  static String maxLengthWithEllipse(String str, int len) {
    // 删除emoji表情
    var sRunes = str.runes;
    return sRunes.length > len
        ? String.fromCharCodes(sRunes, 0, len) + '...'
        : str;
  }

  static bool isDarkMode(BuildContext context) {
    if (Platform.isIOS) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return false;
  }

  static String calcCount(int count) {
    if (count >= 10 * 10000) {
      //100w
      return '10w+';
    }
    if (count >= 1 * 10000) {
      //1w
      return (count / 10000).toStringAsFixed(1) + 'w';
    }

    if (count >= 1 * 1000) {
      //1k
      return (count / 1000).toStringAsFixed(1) + 'k';
    }

    return count.toString();
  }

  static String calcCountInt(int count) {
    if (count >= 10 * 10000) {
      //100w
      return '10w+';
    }
    if (count >= 1 * 10000) {
      //1w
      return (count / 10000).toStringAsFixed(0) + 'w+';
    }

    if (count >= 1 * 1000) {
      //1k
      return (count / 1000).toStringAsFixed(0) + 'k+';
    }

    return count.toString();
  }

  static bool isUrl(String url) {
    return RegExp(
            '(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]')
        .hasMatch(url);
  }

  static int txtCount(String str) {
    int enOrNmCount = 0;
    for (int i = 0; i < str.runes.length; i++) {
      if (RegExp('[\x00-\xff]').hasMatch(str.substring(i, i + 1))) {
        enOrNmCount++;
      }
    }
    if (0 == enOrNmCount) {
      return str.runes.length;
    }
    return str.runes.length - (enOrNmCount ~/ 2).toInt();
  }

  static String maxTxtCount(String str, int count) {
    if (txtCount(str) <= count) {
      return str;
    }

    int total = 0;
    for (int i = 0; i < str.runes.length; i++) {
      if (RegExp('[\x00-\xff]').hasMatch(str.substring(i, i + 1))) {
        total++;
      } else {
        total += 2;
      }
      if (total >= count * 2) {
        return maxLength(str, i + 1);
      }
    }

    return str;
  }

  static String maxTxtCountEllipse(String str, int count) {
    if (txtCount(str) <= count) {
      return str;
    }

    int total = 0;
    for (int i = 0; i < str.runes.length; i++) {
      if (RegExp('[\x00-\xff]').hasMatch(str.substring(i, i + 1))) {
        total++;
      } else {
        total += 2;
      }
      if (total >= count * 2) {
        return maxLength(str, i) + '...';
      }
    }

    return str;
  }

  static Size boundingTextSize(
      BuildContext context, String? text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text == null || text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        locale: Localizations.localeOf(context),
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
}

extension StringExtension on String {
  String insertEmpty() {
    String resultStr = '';
    for (var element in runes) {
      resultStr += String.fromCharCode(element);
      resultStr += '\u200B';
    }
    return resultStr;
  }

  bool isNumber() {
    return isInteger() || isDouble();
  }

  bool isInteger() {
    return int.tryParse(this) != null;
  }

  bool isDouble() {
    return double.tryParse(this) != null;
  }

  bool isPhoneNum() {
    RegExp exp = RegExp(r'^1[3-9]\d{9}$');
    bool matched = exp.hasMatch(this);
    return matched;
  }
}
