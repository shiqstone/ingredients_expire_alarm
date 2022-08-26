import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/mode.dart';
import 'package:ingredients_expire_alarm/pages/home_alarm/item_list_page.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';

class SetModePage extends StatefulWidget {
  const SetModePage({Key? key}) : super(key: key);

  @override
  State<SetModePage> createState() => _SetModePageState();
}

class _SetModePageState extends State<SetModePage> {
  late String choosedMode;

  @override
  void initState() {
    if (SpUtil.getString('mode').isEmpty) {
      choosedMode = Mode.storeMode.name;
      SpUtil.putString('mode', choosedMode);
    } else {
      choosedMode = SpUtil.getString('mode');
    }

    super.initState();
  }

  AppBar _buildBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
          color: Colors.black,
          icon: ImageIcon(ViewUtils.getAssetImage('icon_activity_back')),
          onPressed: () {
            Get.back();
          }),
      title: const Text(
        '模式选择',
        style: TextStyle(fontSize: 18, color: Color(0xFF1E1E1E), fontWeight: FontWeight.bold),
      ),
      elevation: 0.5,
      centerTitle: true,
    );
  }

  Widget _buildItem(String title, Mode itemMode, {bool showDivider = true}) {
    return GestureDetector(
      onTap: () {
        if (choosedMode != itemMode.name) {
          // WidgetsBinding.instance?.addPostFrameCallback((_) {
            var title = '是否切换为';
            if (itemMode == Mode.storeMode) {
              title += '门店';
            } else if (itemMode == Mode.homeMode) {
              title += '家庭';
            }
            title += '模式？';
            Get.defaultDialog(
                content: Text(title),
                title: '',
                onConfirm: () {
                  setState(() {
                    choosedMode = itemMode.name;
                    if (itemMode == Mode.storeMode) {
                      Get.offAll(() => IndexPage());
                    } else if (itemMode == Mode.homeMode) {
                      Get.offAll(() => const HomeAlarmListPage());
                    }
                  });
                  SpUtil.putString('mode', itemMode.name);
                },
                onCancel: () {
                  // Get.back(closeOverlays: true);
                  Get.offAll(() => IndexPage());
                },
                textConfirm: '是',
                confirmTextColor: Colors.white,
                textCancel: '否',
                cancelTextColor: Colors.black);
          // });
        }
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 56.w,
            color: Colors.white,
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 25.0.w, right: 16.w),
                    child: ViewUtils.getImage(
                        choosedMode == itemMode.name ? 'ic_active_check' : 'ic_active_uncheck', 19.w, 19.w)),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            Container(
              width: double.infinity,
              height: 0.5.w,
              color: const Color.fromRGBO(216, 216, 216, 1),
              margin: EdgeInsets.symmetric(horizontal: 17.w),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Material(
      color: const Color.fromRGBO(247, 247, 247, 0),
      child: Column(
        children: [_buildItem('门店模式', Mode.storeMode), _buildItem('家庭模式', Mode.homeMode)],
      ),
    );
  }

  Widget buildRadiusView(Widget child, double radius) {
    return ClipRRect(
      child: child,
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
