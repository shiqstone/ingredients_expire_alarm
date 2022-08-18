import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertUtil {
  static show({required String title, String? content, String? cancelBtnTitle, String? okBtnTitle, VoidCallback? okBtnTap}) {
      return showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (context) {
            return ExAlertDialog(
              content: ExDialogContent(
                title: title,
                content: content,
                cancelBtnTitle: cancelBtnTitle,
                okBtnTitle: okBtnTitle,
                okBtnTap: okBtnTap,
              ),
            );
          });

  }
}

class ExAlertDialog extends AlertDialog {
  ExAlertDialog({Key? key, required Widget content})
      : super(key: key, 
    content: content,
    contentPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.w),
    ),
  );
}

class ExDialogContent extends StatelessWidget {
  final String title;
  final String? content;
  final String? okBtnTitle;
  final String? cancelBtnTitle;
  final VoidCallback? okBtnTap;

  const ExDialogContent({Key? key, required this.title, this.content, this.okBtnTitle, this.cancelBtnTitle, this.okBtnTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30.w),
        constraints: BoxConstraints(minHeight: 180.h, maxHeight: 190.h),
        width: 343.w,
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!StringUtil.isEmpty(title)) Container(
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: themeColor.titleBlackColor),
                )),
            if (!StringUtil.isEmpty(content)) Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  content ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: themeColor.titleBlackColor),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(
                    cancelBtnTitle ?? 'cancel',
                    style: TextStyle(
                        color: themeColor.titleBlackColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith((states) {
                      return themeColor.primaryColor.withOpacity(0.4);
                    }),
                    minimumSize: MaterialStateProperty.all(
                        Size(102.w, 36.h)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.w)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    okBtnTitle ?? 'ok',
                    style: TextStyle(
                        color: themeColor.titleWhiteColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith((states) {
                      return themeColor.primaryColor;
                    }),
                    minimumSize: MaterialStateProperty.all(
                        Size(102.w, 36.h)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.w)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (okBtnTap != null) okBtnTap!();
                  },
                ),
              ],
            ),
          ],
        ));
  }
}