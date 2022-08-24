import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

///多语言
class CurrentLocale with ChangeNotifier
{
  Locale _locale = const Locale('zh','CN');

  Locale get value => _locale;
  void setLocale(locale)
  {
    _locale = locale;
    notifyListeners();
  }
}

///多主题
class CurrentTheme extends ChangeNotifier{
  //当前主题
  AppThemeEnum _nowAppTheme = AppThemeEnum.defaultTheme;

  AppThemeEnum get getThisThemeColor => _nowAppTheme;

  setTheme(AppThemeEnum themeColor) {
    _nowAppTheme = themeColor;
    notifyListeners();
  }

}

//主题枚举
enum AppThemeEnum { defaultTheme, blackTheme }

//主题实体类
class ThemeBean {
  //主题色
  Color primaryColor;
  //主题色2
  Color primaryColor2;
  //主题色3
  Color primaryColor3;
  //title 浅标题颜色
  Color titleLightColor;
  //title 深颜色
  Color titleBlackColor;
  //title 白色
  Color titleWhiteColor;
  //主背景色
  Color mainBgColor;
  //二级背景色
  Color secondLevelMainBgColor;
  //未选中颜色
  Color unselectedWidgetColor;
  //选中颜色
  Color activeColor;
  //下划线颜色
  Color underlineColor;
  //底部导航栏颜色
  Color systemNavigationBarColor;
  //二级title颜色
  Color secondLevelTitleColor;
  //facebook
  Color facebookColor;
  //ins
  Color insColor;
  //twitter
  Color twitterColor;
  //google
  Color googleColor;

  ThemeBean(
      this.primaryColor,
      this.primaryColor2,
      this.primaryColor3,
      this.titleLightColor,
      this.titleBlackColor,
      this.titleWhiteColor,
      this.mainBgColor,
      this.unselectedWidgetColor,
      this.activeColor,
      this.underlineColor,
      this.systemNavigationBarColor,
      this.secondLevelTitleColor,
      this.secondLevelMainBgColor,
      this.facebookColor,
      this.insColor,
      this.twitterColor,
      this.googleColor,
      );
}

//默认主题
ThemeBean defaultTheme = ThemeBean(
  //主题色
  const Color(0xff499D2F),
  //主题色2
  const Color(0xFFF6C30C),
  //主题色3
  const Color(0xFFF47509),
  //主标题浅色
  const Color(0xff999999),
  //主标题深色
  const Color(0xff000000),
  //主标题白色
  const Color(0xffffffff),
  //主背景色
  const Color(0xffFAFAFF),
  //未选中颜色
  const Color(0xff000000).withOpacity(0.12),
  //选中颜色
  Colors.blue,
  //下划线颜色
  const Color(0xffe6e6e6),
  //底部导航栏颜色
  const Color(0xfff2f2f2),
  //二级标题颜色
  const Color(0xff056141),
  //二级背景色
  const Color(0xffffffff),
  //facebook
  const Color(0xff0975F6),
  //ins
  const Color(0xffffffff),
  //twitter
  const Color(0xff00BDF2),
  //google
  const Color(0xffffffff),
);


//暗黑主题
ThemeBean blackTheme = ThemeBean(
  //主题色
  const Color(0xffffffff),
  //主题色2
  const Color(0xfff0f0f0),
  //主题色3
  const Color(0xfff0f0f0),
  //主标题浅色
  Colors.white,
  //主标题深色
  Colors.white,
  //主标题白色
  const Color(0xff000000),
  //主背景色
  const Color(0xff111111),
  //未选中颜色
  const Color(0xff2c2c2c),
  //选中颜色
  const Color(0xff2c2c2c),
  //下划线颜色
  const Color(0xff3b3b3b),
  //底部导航栏颜色
  const Color(0xff010101),
  //二级标题颜色
  const Color(0xff979797),
  //二级背景色
  const Color(0xff424242),
  //facebook
  const Color(0xff0975F6),
  //ins
  const Color(0xffffffff),
  //twitter
  const Color(0xff00BDF2),
  //google
  const Color(0xffffffff),
);

//主题数组
Map<AppThemeEnum, ThemeBean> themeMap = {
  AppThemeEnum.defaultTheme: defaultTheme,
  AppThemeEnum.blackTheme: blackTheme
};

//获取颜色
ThemeBean get themeColor => themeMap[
// Provider.of<CurrentTheme>(navigatorKey.currentState!.overlay!.context)
//     .getThisThemeColor]!;
Provider.of<CurrentTheme>(Get.context!, listen: false)
.getThisThemeColor]!;
