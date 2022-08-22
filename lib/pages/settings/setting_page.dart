import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/pages/settings/backup_page.dart';
import 'package:ingredients_expire_alarm/pages/settings/item_list_page.dart';
import 'package:ingredients_expire_alarm/public.dart';

import 'package:ingredients_expire_alarm/util/view_utils.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      appBar: buildAppBar(),
      body: buildContentView(),
    ));
  }

  Widget buildContentView() {
    return Column(
      children: [
        Expanded(
            child: ListView(
          children: <Widget>[
            SizedBox(
              height: 16.w,
            ),
            buildSettingCommon(
              "物品列表",
              () => Get.off(() => const ItemListPage()),
              showDivider: true,
            ),
            SizedBox(
              height: 16.w,
            ),
            // buildSettingCommon(
            //     "隐私设置", () => Get.to(() => PrivacySettingPage())),
            // SizedBox(
            //   height: 16.w,
            // ),
            buildSettingCommon(
              "备份",
              () => Get.to(() => BackupPage()),
              showDivider: true,
            ),
            SizedBox(
              height: 16.w,
            ),
            // buildSettingCommon("诊断", () => Get.to(() => DiagnosisPage())),
            // SizedBox(
            //   height: 16.w,
            // ),
            // Container(
            //   margin: EdgeInsets.only(bottom: 15.h),
            //   child: buildExitView(),
            // ),
          ],
        )),
      ],
    );
  }

  // Widget _buildAnimate(){
  //   return Container(
  //     color: Colors.white,
  //     width: double.infinity,
  //     height: double.infinity,
  //     child: Lottie.asset('assets/images/animate_test.json',
  //         reverse: true,
  //         repeat: true,
  //         width: double.infinity,
  //         height: double.infinity,
  //         fit: BoxFit.fitWidth
  //     ),
  //   );
  // }

  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        // leading: IconButton(
        //     icon: ImageIcon(ViewUtils.getAssetImage('icon_activity_back')),
        //     color: Colors.black,
        //     onPressed: () {
        //       Get.back();
        //     }),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '设置',
              style: TextStyle(fontSize: 18.sp, color: const Color(0xFF222222), fontWeight: FontWeight.bold),
            ),
            // SizedBox(height: 16.w, width: (SizeFit.screenWidth?? 240.w / 2) - 5.w),
            // IconButton(
            //   icon: ViewUtils.getImage(
            //     'ic_active_add_img',
            //     24.w,
            //     24.w,
            //     // color: themeColor.primaryColor,
            //   ),
            //   onPressed: () => Get.to(() => const FullScreenScannerPage(srcPath: 'addItem')),
            // ),
          ],
        ),
        elevation: 0.5);
  }

  // Widget buildExitView() {
  //   return Material(
  //     color: Colors.white,
  //     child: InkWell(
  //         onTap: () {
  //           showExitDialog();
  //         },
  //         child: Container(
  //           color: Colors.white,
  //           padding: EdgeInsets.symmetric(vertical: 14.0.h),
  //           child: Center(
  //             child: Text('退出登录',
  //                 style: TextStyle(
  //                     wordSpacing: 4, fontWeight: FontWeight.bold, fontSize: 14.sp, color: Color(0xFF070B25))),
  //           ),
  //         )),
  //   );
  // }

  SettingCommon buildSettingCommon(
    String title,
    VoidCallback callback, {
    bool showDivider = false,
    bool showMore = true,
  }) {
    return SettingCommon(
      title: title,
      content: "",
      onPressed: callback,
      showDivider: showDivider,
      showMore: showMore,
    );
  }

  void showExitDialog({bool isLogout = true}) {
    Get.dialog(AlertDialog(
      content: Text(isLogout ? '退出登录?' : '切换账户'),
      actions: <Widget>[
        TextButton(
          child: const Text('确定'),
          onPressed: () {},
        ),
        TextButton(
          child: const Text('取消'),
          onPressed: () => Get.back(),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 20,
      // 设置成 圆角
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
    ));
  }
}

//普通条目布局
class SettingCommon extends StatelessWidget {
  final VoidCallback onPressed;
  final bool showDivider;
  final bool showMore;

  const SettingCommon({
    Key? key,
    required this.title,
    required this.content,
    required this.onPressed,
    this.showDivider = false,
    this.showMore = true,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: InkWell(
          onTap: onPressed,
          child: IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 16.0.w),
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        child: Text(title,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0.w),
                      child: Text(content, style: TextStyle(fontSize: 14.sp, color: Colors.black)),
                    ),
                    if (showMore)
                      Container(
                        margin: EdgeInsets.only(left: 5.0.w, right: 15.w),
                        child: ViewUtils.getImage(
                          "icon_active_more",
                          8.w,
                          12.h,
                        ),
                      ),
                  ],
                ),
                if (showDivider)
                  Container(
                    height: 0.5.w,
                    width: 343.w,
                    color: const Color.fromRGBO(216, 216, 216, 1),
                  ),
              ],
            ),
          ),
        ));
  }
}
