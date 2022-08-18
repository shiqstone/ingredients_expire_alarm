import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:ingredients_expire_alarm/public.dart';

class ToastUtil {
  static show(String? msgStr) {
    showToast(
      msgStr ?? '',
      duration: const Duration(seconds: 2),
      dismissOtherToast: true,

    );
    // showToast(
    //     msg: msgStr ?? '',
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     backgroundColor: Color(0xff575757),
    //      textColor: Colors.white,
    //     fontSize: 14.0
    // );
  }

  static showCongratulations(String? msgStr) {
    // Fluttertoast.showToast(
    //     msg: msgStr ?? '',
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.TOP,
    //     backgroundColor: Colors.white,
    //     textColor: Colors.black,
    //     fontSize: 22.sp
    // );
    showToast(
      msgStr ?? '',
      duration: const Duration(seconds: 2),
      dismissOtherToast: true,
      backgroundColor: Colors.white,
      textStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500, color: Colors.black),
      position: ToastPosition.top,
      textPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }

  // static showLoading() {
  //   showToastWidget(
  //     loading(),
  //     handleTouch: false,
  //     duration: const Duration(seconds: 30),
  //   );
  // }

  static hiddenLoading() {
    dismissAllToast(showAnim: true);
  }

  // static Widget loading() {
  //   return Center(
  //     child: Container(
  //       alignment: Alignment.center,
  //       height: 150.w,
  //       child: Lottie.asset('assets/json/loading.json',
  //           height: 150.w, width: 150.w, repeat: true, fit: BoxFit.cover),
  //     ),
  //   );
  // }

}
