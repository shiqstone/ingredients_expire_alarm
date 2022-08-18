import 'package:flutter/foundation.dart';

class Constant {
  static const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: kReleaseMode ? 'online' : 'debug');

  static const Map<String, dynamic> envConfigs = {
    'debug': {
      'baseUrl': '',
      'seckey': '1a229752c483f57994efb9a0e64d0139',
    },
    'online': {
      'baseUrl': '',
      'seckey': '1a229752c483f57994efb9a0e64d0139',
    },
  };
  static Map<String, dynamic> envConfig = envConfigs[appEnv];
  static String wonderUrl = envConfigs[appEnv]['baseUrl'];

  static String channel = const String.fromEnvironment('APP_CHANNEL', defaultValue: "iea");

  static const String ASSETS_IMG = 'assets/images/';

  static const bool ISDEBUG = !bool.fromEnvironment("dart.vm.product");

  static const String SP_USER = 'sp_user';

  static const String SP_KEYBOARD_HEGIHT = 'sp_keyboard_hegiht'; //软键盘高度

  static const int PAGE_SIZE = 20;


  static int _currentHomePageIndex = 1;

  static void setIndex(int index) {
    _currentHomePageIndex = index;
  }

  static int getIndex() {
    return _currentHomePageIndex;
  }

  static const String ZWS = '\u00A0'; //'\u200C';
}

class AppConfig {
  static const String appId = 'org.benstone.sbs_alarm';
  static const String appName = 'Sbs_Alarm';
  static const String version = '0.0.1';
  static const bool isDebug = kDebugMode;
}

class ViewStatus {
  static const int fail = -1;
  static const int loading = 0;
  static const int success = 1;
  static const int empty = 2;
  static const int noMore = 3;
}
