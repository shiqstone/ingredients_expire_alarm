import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/db/home_alarm_db_manage.dart';
import 'package:ingredients_expire_alarm/model/home_item_alarm.dart';
import 'package:ingredients_expire_alarm/pages/home_alarm/item_list_page.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/utils.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';
import 'package:ingredients_expire_alarm/vm/alarm_list_vm.dart';

import 'count_down_widget.dart';

class AlarmItemView extends StatefulWidget {
  final int index;
  final HomeItemAlarm? entity;
  final VoidCallback? onPressed;
  const AlarmItemView({Key? key, required this.index, required this.entity, required this.onPressed}) : super(key: key);

  @override
  State<AlarmItemView> createState() => _AlarmItemViewState();
}

class _AlarmItemViewState extends State<AlarmItemView> {
  bool isAlarming = false;
  // late AlarmListVM _vm;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _vm = AlarmListVM.instance;
  }

  final HomeAlarmDbManage _databaseManage = HomeAlarmDbManage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10.w, right: 16.w),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              height: 64.w,
              decoration: BoxDecoration(
                  color: isAlarming ? themeColor.primaryColor2 : themeColor.titleWhiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(16.w)),
                  border: Border.all(
                      width: 0.5.w, color: widget.index == -1 ? themeColor.primaryColor : themeColor.underlineColor)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                                onTap: () => widget.onPressed!(),
                                child: Text(Utils.maxLengthWithEllipse(widget.entity?.name ?? '', 10),
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: isAlarming ? themeColor.titleWhiteColor : themeColor.titleLightColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp))),
                            SizedBox(
                              height: 15.w,
                              width: 22.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CountDownWidget(
                      index: widget.index,
                      validTime: widget.entity!.alarmTime!,
                      switchAlarm: switchAlarm,
                      isAlarming: isAlarming),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => onDisable(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ViewUtils.getImage('ic_checked', 25.w, 21.w),
                            SizedBox(
                              height: 4.w,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.w,
                        width: 12.w,
                      ),
                      // Visibility(
                      //   visible: isAlarming,
                      //   child: GestureDetector(
                      //     onTap: () => onDismiss(),
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         ViewUtils.getImage('ic_bell_off', 25.w, 21.w),
                      //         SizedBox(
                      //           height: 4.w,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void switchAlarm(bool isAlarming) {
    this.isAlarming = isAlarming;
    // return res;
  }

  Future<void> onDisable() async {
    Get.defaultDialog(
        content: const Text(''),
        title: '移除定时？',
        onConfirm: () async {
          widget.entity!.status = AlarmStatus.disable.index + 1;
          await _databaseManage.updateHomeItemAlarm(widget.entity!);

          // FlutterRingtonePlayer.stop();
          // isAlarming = false;
          // _vm.alarmingMap[widget.entity!.barcode!] = isAlarming;

          if (mounted) {
            setState(() {});
          }
          AlarmListVM.instance.loadData();

          Get.offAll(() => const HomeAlarmListPage());
        },
        onCancel: () {
          Get.back();
        },
        textConfirm: '是',
        confirmTextColor: Colors.white,
        textCancel: '否',
        cancelTextColor: Colors.black);
  }

  // Future<void> onDismiss() async {
  //   FlutterRingtonePlayer.stop();
  // }
}
