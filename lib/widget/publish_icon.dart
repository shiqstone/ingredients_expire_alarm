import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PublishIcon extends StatelessWidget {
  const PublishIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.w),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB6B6),
                  blurRadius: 6.w,
                  offset: Offset(0.0, 8.w), //阴影xy轴偏移量
                  spreadRadius: 0,
                )
              ],
            ),
          ),
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.w),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFF95546),
                  Color(0xFFFF87B9),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 14.w,
                  height: 4.w,
                  color: Colors.white,
                ),
                Container(
                  width: 4.w,
                  height: 14.w,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
