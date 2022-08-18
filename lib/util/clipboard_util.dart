import 'package:flutter/services.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/string_util.dart';

//复制粘贴
class ClipboardUtil {
  //复制内容
  static setData(String? data) {
    if (!StringUtil.isEmpty(data)) {
      Clipboard.setData(ClipboardData(text: data));
    }
  }

  //复制内容
  static setDataAndToast(String? data, {String? toastMsg}) {
    if (!StringUtil.isEmpty(data)) {
      Clipboard.setData(ClipboardData(text: data));
      ToastUtil.show(toastMsg ?? 'Get It');
    }
  }

  //获取内容
  static Future<ClipboardData?> getData() {
    return Clipboard.getData(Clipboard.kTextPlain);
  }

//将内容复制系统
//   ClipboardUtil.setData('123');
//从系统获取内容
//   ClipboardUtil.getData().then((data){}).catchError((e){});

}
