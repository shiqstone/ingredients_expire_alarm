import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/global.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
Future<void> main() async {
  await runZonedGuarded(() async {
    Global.init(() {
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CurrentLocale()),
          ChangeNotifierProvider(create: (context) => CurrentTheme())
        ],
        child: const MyApp(),
      ));
    });
  }, (error, stackTrace) {});
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, //状态栏
    systemNavigationBarColor: Colors.white, //虚拟按键背景色
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark, //虚拟按键图标色
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  // runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    setState(() {
      _locale = const Locale('zh', 'CH');
    });
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        // DotUtil.dotEvent('LAUNCHER',label: 'pause');
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        // DotUtil.dotEvent('LAUNCHER',label: 'resumed');
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        // DotUtil.dotEvent('LAUNCHER',label: 'pause');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentLocale>(builder: (context, currentLocale, child) {
      return Consumer<CurrentTheme>(builder: (context, themeColor, child) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          // allowFontScaling: false,
          builder: (context, child) {
            return OKToast(
                dismissOtherOnShow: true,
                child: GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Ingredients Expire Alarm',
                  localizationsDelegates: const [
                    //此处
                    RefreshLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    // CustomLocalizations.delegate
                  ],
                  locale: _locale,
                  supportedLocales: const <Locale>[
                    Locale('en', 'US'),
                    Locale('zh', 'CN'),
                  ],
                  navigatorObservers: [
                    routeObserver,
                  ],
                  // You can use the library anywhere in the app even in theme
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
                  ),
                  home: child,
                ));
          },
          child: IndexPage(),
        );
      });
    });
  }
}
