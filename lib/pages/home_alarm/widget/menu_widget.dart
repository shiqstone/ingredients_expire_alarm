import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ingredients_expire_alarm/util/string_util.dart';

class MenuBottomWidget extends StatelessWidget {

  final List<MenuItem> items;

  const MenuBottomWidget({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white.withOpacity(0.3),
        child: Column(
          mainAxisSize: MainAxisSize.min, //wrap_content
          children: items.map((item) {
            return Column(
              children: [
                _buildItem(context, item.title, item.onTap, corner: items.indexOf(item) == 0),
                items.indexOf(item) == items.length - 1 ? Container(
                  width: double.infinity,
                  height: ScreenUtil().bottomBarHeight.h,
                  color: Colors.white.withOpacity(0.3),
                ) : _line,
              ],
            );
          }).toList(),
        )
    );
  }

  Widget get _line => Container(
    height: 1.h,
    color: Colors.white,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      height: 1.h,
      width: 100,
      color: const Color(0xFFF5F5F5),
    ),
  );


  Widget _buildItem(BuildContext context, String title, GestureTapCallback onTap, {bool corner = true}){
    Radius radius =  Radius.circular(corner ? 4.w : 0);
    return
      Material(
        child: InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: radius,topRight: radius),
              ),
              height: 50.h,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1,
                    color: StringUtil.isEqual(title, '取消') ? const Color(0xFF969696) : Colors.black,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            )
        ),
      );
  }
}

class MenuItem{

  MenuItem(this.title, this.onTap);
  String title;
  GestureTapCallback onTap;

}
