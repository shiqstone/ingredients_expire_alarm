import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/widget/lazy_index_stack.dart';

import '../scanner/full_screen_scanner_page.dart';
import 'alarm/item_list_page.dart';
import 'settings/setting_page.dart';

class IndexPage extends StatefulWidget {
  late int tindex = 0;
  // static final String EVENT_SET_HOME_INDEX = "event_set_home_index";
  IndexPage({Key? key, String? showSeed = '0', this.tindex = 0}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final IndexCtr mCtr = Get.put(IndexCtr());

  String? showSeed;

  final List<String> appBarTitles = ['列表', '', '设置'];

  Text getTabTitle(int curIndex) {
    if (curIndex == mCtr.tabIndex.value) {
      return Text(appBarTitles[curIndex], style: TextStyle(fontSize: 10.0.sp, color: Colors.black));
    } else {
      return Text(appBarTitles[curIndex], style: TextStyle(fontSize: 10.0.sp, color: const Color(0x88000000)));
    }
  }

  final List<Widget> tabBodies = [
    const AlarmListPage(),
    const FullScreenScannerPage(srcPath: 'scan'),
    // QRViewPage(),
    const SettingPage(),
    // ItemListPage()
  ];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      mCtr.tabIndex.value = widget.tindex;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      mCtr.seedHadShow = true;
    });
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GetBuilder(
        init: IndexCtr(),
        initState: (_) => mCtr.init(),
        builder: (ctr) => getBody(),
      ), //getBody
    );
  }

  List<BottomNavBarItem> _navBarsItems() {
    return [
      buildBottomBarItem(getTabIcon(0), getTabTitle(0)),
      buildBottomBarItem(getTabIcon(1), getTabTitle(1)),
      // buildBottomBarItem(PublishIcon(), getTabTitle(1)),
      buildBottomBarItem(getTabIcon(2), getTabTitle(2)),
    ];
  }

  BottomNavBarItem buildBottomBarItem(Widget icon, Widget title) {
    return BottomNavBarItem(
      icon: icon,
      title: title,
    );
  }

  Color getTabBottomColor() {
    // if( mCtr.tabIndex.value == 1){
    //   return Color(0xFF010001);
    // }
    return Colors.white;
  }

  Widget getBody() {
    return WillPopScope(
      child: Stack(
        children: [
          Scaffold(
              backgroundColor: getTabBottomColor(),
              bottomNavigationBar: Container(
                padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight.h),
                child: Obx(() => _buildBottomBarView()),
              ),
              // body: Obx(() => IndexedStack(
              //       index: mCtr.tabIndex.value,
              //       children: tabBodies,
              //     )),
              body: Obx(() => LazyIndexedStack(
                    reuse: false,
                    index: mCtr.tabIndex.value,
                    itemBuilder: (c, i) {
                      return tabBodies[i];
                    },
                    itemCount: tabBodies.length,
                  ))),
        ],
      ),
      onWillPop: () async {
        // 点击返回键的操作
        if (DateTime.now().difference(mCtr.lastPopTime.value) > const Duration(seconds: 2)) {
          mCtr.lastPopTime.value = DateTime.now();
          ToastUtil.show('再按一次退出应用');
        } else {
          mCtr.lastPopTime.value = DateTime.now();
          // 退出app
          // DotUtil.onExit();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return false;
      },
    );
  }

  Widget _buildBottomBarView() {
    return CustomNavBarWidget(
      // Your custom widget goes here
      items: _navBarsItems(),
      selectedIndex: mCtr.currentPage.value,
      unreadNum: mCtr.unReadNum.value,
      onItemSelected: (index) {
        mCtr.tabIndex.value = index;
        mCtr.currentPage.value = index; // NOTE: THIS IS CRITICAL!! Don't miss it!
      },
    );
  }

  Image getTabIcon(int curIndex) {
    if (curIndex == mCtr.tabIndex.value) {
      return mCtr.tabImages[curIndex][1];
    }
    return mCtr.tabImages[curIndex][0];
  }
}

class BottomNavBarItem {
  BottomNavBarItem({required this.icon, required this.title});

  Widget icon;
  Widget title;
}

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<BottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  final int unreadNum;

  const CustomNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
    this.unreadNum = 0,
  });

  Widget _buildItem(BottomNavBarItem item, int index) {
    Widget _showUnreadNum = Container();
    if (index == 1 && unreadNum > 0) {
      _showUnreadNum = Positioned(
          left: ScreenUtil().screenWidth / 10 + 7,
          top: 2.h,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              constraints: BoxConstraints(
                minWidth: 10.w,
                minHeight: 10.w,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffFA5151), //Color(0xffFF1D25),
                borderRadius: BorderRadius.circular(5.w),
              ),
              padding: const EdgeInsets.only(left: 1, right: 1),
            ),
          ));
    }

    return GestureDetector(
        onTap: () {
          onItemSelected(index);
        },
        child: Container(
          color: Colors.transparent,
          // alignment: Alignment.center,
          // height: 49.0.w,
          child: index == 1
              ? Column(
                  children: [
                    SizedBox(height: 7.h),
                    item.icon,
                  ],
                )
              : Stack(
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 8.h),
                          item.icon,
                          SizedBox(height: 2.h),
                          item.title,
                        ],
                      ),
                    ),
                    _showUnreadNum,
                  ],
                ),
        ));
  }

  Color getTabBottomColor() {
    // if( selectedIndex == 1){
    //   return Color(0xFF010001);
    // }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0x209E9E9E),
              blurRadius: 3.h,
              offset: Offset(0.0, -3.h), //阴影xy轴偏移量
              spreadRadius: 0,
            )
          ],
          color: getTabBottomColor(),
        ),
        width: double.infinity,
        height: 58.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items.map((item) {
            int index = items.indexOf(item);
            return Flexible(child: _buildItem(item, index));
          }).toList(),
        ),
      ),
    );
  }
}

class IndexCtr extends GetxController {
  final tabIndex = 0.obs;
  final currentPage = 0.obs;
  final lastPopTime = DateTime.now().obs;

  final unReadNum = 0.obs;

  bool seedHadShow = false;

  List<List<Image>> tabImages = [];

  Image getTabImage(path, {bool little = true}) {
    return Image.asset(
      path,
      width: (little ? 20.0.w : 30.w),
      gaplessPlayback: true,
      height: (little ? 20.0.w : 30.w),
      fit: BoxFit.fill,
    );
  }

  void init() {
    tabImages = [
      [getTabImage('assets/images/tabbar_home.png'), getTabImage('assets/images/tabbar_home_highlighted.png')],
      // [
      //   getTabImage('assets/images/tabbar_find.png'),
      //   getTabImage('assets/images/tabbar_find_highlight.png')
      // ],
      [
        getTabImage('assets/images/ic_msg_camera.png', little: false),
        getTabImage('assets/images/ic_msg_camera.png', little: false),
      ],
      // [
      //   getTabImage('assets/images/tabbar_message_center.png'),
      //   getTabImage('assets/images/tabbar_message_center_highlighted.png')
      // ],
      [getTabImage('assets/images/tabbar_profile.png'), getTabImage('assets/images/tabbar_profile_highlighted.png')],
    ];
  }

  int time = 0;

  bool isDoubleClick() {
    if (time > 0 && DateTime.now().millisecondsSinceEpoch - time < 1000) {
      time = 0;
      return true;
    }
    time = DateTime.now().millisecondsSinceEpoch;
    return false;
  }
}
