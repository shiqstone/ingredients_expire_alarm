import 'dart:io';

// import 'package:amap_flutter_location/amap_flutter_location.dart';
// import 'package:ingredients_expire_alarm/db/base_db_provider.dart';
import 'package:ingredients_expire_alarm/util/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_bugly/flutter_bugly.dart';


class Global {
  //初始化全局信息
  static Future init(VoidCallback callback) async {
    WidgetsFlutterBinding.ensureInitialized();

    // await SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]); //禁止应用横屏,强制竖屏

    await SpUtil.getInstance();
    // await BaseDbProvider().init();
    // await _initChannelName();

    // AMapFlutterLocation.setApiKey(
    //     Constant.AMAPAPIKEY_ANDROID, Constant.AMAPAPIKEY_IOS);
    callback();

    if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    // FlutterBugly.init(
    //   androidAppId: Constant.envConfig['bugly']['androidAppId'],
    //   iOSAppId: Constant.envConfig['bugly']['iosAppId'],
    //   channel: Constant.channel,
    // );
  }

  // static _initChannelName() async {
  //   Constant.channel = await CallNative().getChannelName();
  // }
}
