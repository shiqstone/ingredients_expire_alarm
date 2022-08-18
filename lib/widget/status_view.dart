import 'package:flutter/material.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';

class StatusView extends StatelessWidget{
  final String? title;
  final String? icon;
  final GestureTapCallback? onTap;
  const StatusView({Key? key, this.onTap, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ViewUtils.getImage(icon ?? 'ic_empty', 141.w, 104.w),
            SizedBox(height: 16.w,),
            Text(
              title ?? '记录为空',
              style: TextStyle(color: themeColor.titleLightColor, fontSize: 15.sp, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
  
}