import 'package:ingredients_expire_alarm/util/string_util.dart';
import 'package:flutter/material.dart';

class Colours {
  static const Color app_main = Color(0xFF666666);
  static const Color app_bg = Color(0xfff5f5f5);

  static const Color transparent = Color(0x00000000); //<!--204-->
  static const Color transparent_80 = Color(0xCC000000); //<!--204-->
  static const Color transparent_60 = Color(0x99000000); //<!--204-->
  static const Color transparent_70 = Color(0xB2000000); //<!--204-->
  static const Color white_19 = Color(0X19FFFFFF);
  static const Color transparent_12 = Color(0x0B000000); //<!--204-->

  static const Color text_dark = Color(0xFF333333);
  static const Color text_normal = Color(0xFF666666);
  static const Color text_gray = Color(0xFF999999);

  static const Color divider = Color(0xffe5e5e5);

  static const Color gray_33 = Color(0xFF333333); //51
  static const Color gray_66 = Color(0xFF666666); //102
  static const Color gray_99 = Color(0xFF999999); //153
  static const Color common_orange = Color(0XFFFC9153); //252 145 83
  static const Color gray_ef = Color(0XFFEFEFEF); //153

  static const Color gray_f0 = Color(0xfff0f0f0); //<!--204-->
  static const Color gray_f5 = Color(0xfff5f5f5); //<!--204-->
  static const Color gray_cc = Color(0xffcccccc); //<!--204-->
  static const Color gray_ce = Color(0xffcecece); //<!--206-->
  static const Color green_1 = Color(0xff009688); //<!--204-->
  static const Color green_62 = Color(0xff626262); //<!--204-->
  static const Color green_e5 = Color(0xffe5e5e5); //<!--204-->

  static const Color green_de = Color(0xffdedede);

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color logo_green = Color(0x1D00ADA0);

  static const Color blogTextColor = Color(0xFF1C2339);

  static const Color blogIntroduceColor = Color(0xFF838383);

  static const Color border_shadow = Color(0x1D000000);

  static const Color normalGreen = Color(0xFF00ADA0);

  static const Color black1 = Color(0xFF070B25);
  static const Color common_txt_black = Color(0xFF1E1E1E);

  /**
   * 获取群体身份文字色彩以及背景色彩
   */
  static Color getUserColorTxtOrBgColor(String? color,
      {bool isBg = false, bool female = false}) {
    if (StringUtil.isEmpty(color) || female) {
      return isBg ? Color(0xFFFFEAF0) : Color(0xFFFF4A81);
    }

    // if(StringUtil.isEqualToLower(color, 'straight')){
    //   if(female){
    //     return isBg ? Color(0xFFFFEBEB) : Color(0xFFFF5B5B);
    //   }
    //   return isBg ? Color(0xFFDCF9FF) : Color(0xFF09C3EE);
    // }
    //
    //
    // if(StringUtil.isEqualToLower(color, 'bisexual')){
    //   return isBg ? Color(0xFFD8FFED) : Color(0xFF24DB87);
    // }
    //
    //
    // if(StringUtil.isEqualToLower(color, 'transgender')){
    //   return isBg ? Color(0xFFFFF6D8) : Color(0xFFFAC61B);
    // }
    //
    //
    // if(StringUtil.isEqualToLower(color, 'other')){
    //   return isBg ? Color(0xFFFAE3FF) : Color(0xFFDA4DFC);
    // }
    //
    // if(color.toLowerCase().startsWith('gay')){
    //   return isBg ? Color(0xFFE8F3FF) : Color(0xFF3D99FC);
    // }
    //
    // return isBg ? Color(0xFFFFEAF0) : Color(0xFFFF4A81);
    return isBg ? Color(0xFFE1ECFF) : Color(0xFF1D86FF);
  }

  static String getImgByUserColor(String? color, bool female) {
    if (StringUtil.isEmpty(color)) {
      return '';
    }

    if (StringUtil.isEqualToLower(color, 'straight')) {
      return female ? 'ic_f_straight' : 'ic_m_straight';
    }

    if (StringUtil.isEqualToLower(color, 'bisexual')) {
      return female ? 'ic_f_bisexual' : 'ic_m_bisexual';
    }

    if (StringUtil.isEqualToLower(color, 'transgender')) {
      return female ? 'ic_f_transgender' : 'ic_m_t';
    }

    if (StringUtil.isEqualToLower(color, 'queer')) {
      return female ? 'ic_f_queer' : 'ic_m_queer';
    }

    if (StringUtil.isStartsToLower(color, 'other')) {
      return female ? 'ic_f_other' : 'ic_m_other';
    }

    if (color!.toLowerCase().startsWith('gay')) {
      return 'ic_m_gay';
    }

    return 'ic_f_les';
  }

  // 十六进制颜色转RGB
  // hex, 十六进制值，例如：0xffffff,
  // alpha, 透明度 [0.0,1.0]
  static Color hexColor(int hex, {double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0, alpha);
  }
}
