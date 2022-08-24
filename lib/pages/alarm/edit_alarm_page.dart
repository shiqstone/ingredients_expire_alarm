import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/db/alarm_db_manage.dart';
import 'package:ingredients_expire_alarm/model/item_alarm.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/date_util.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';

import 'package:async/async.dart' show AsyncMemoizer;

class EditAlarmRecordPage extends StatefulWidget {
  final int id;
  const EditAlarmRecordPage({Key? key, required this.id}) : super(key: key);

  @override
  _AddAlarmRecordPageState createState() => _AddAlarmRecordPageState();
}

class _AddAlarmRecordPageState extends State<EditAlarmRecordPage> {
  late var barcodeCtr = TextEditingController();
  late var itemNameCtr = TextEditingController();
  // late var descriptCtr = TextEditingController();
  var ptypes = ['小时', '天', '月'];
  int ptype = 0;
  late var periodCtr = TextEditingController();
  DateTime? openTime;
  DateTime? expireTime;
  DateTime? alarmTime;

  bool? bcMode;

  // ItemRecord? item;
  ItemAlarm? itemAlarm;

  final AlarmDbManage _alarmDbMgr = AlarmDbManage();
  // final ItemDbManage _itemDbMgr = ItemDbManage();

  @override
  void initState() {
    super.initState();
    // initCtr();
  }

  Future<void> loadData() async {
    itemAlarm = await _alarmDbMgr.getItemById(widget.id);
    if (itemAlarm != null) {
      // item = await _itemDbMgr.getItemByBarcode(itemAlarm!.barcode!.toString());

      if (itemAlarm?.barcode != null) {
        barcodeCtr = TextEditingController(text: itemAlarm?.barcode!.toString());
      }
      itemNameCtr = TextEditingController(text: itemAlarm?.name);
      // descriptCtr = TextEditingController(text: item?.description);

      expireTime = itemAlarm?.expireDate;
      alarmTime = itemAlarm?.alarmTime;

      int period = 0;
      if ((itemAlarm?.validityPeriod)! > 86400 * 30) {
        ptype = 2;
        period = ((itemAlarm?.validityPeriod)! / 86400 / 30).round();
      } else if ((itemAlarm?.validityPeriod)! > 86400) {
        ptype = 1;
        period = ((itemAlarm?.validityPeriod)! / 86400).round();
      } else {
        ptype = 0;
        period = ((itemAlarm?.validityPeriod)! / 3600).round();
      }
      periodCtr = TextEditingController(text: period.toString());
    }
    openTime = alarmTime!.subtract(Duration(seconds: itemAlarm!.validityPeriod!));
  }

  @override
  void dispose() {
    barcodeCtr.dispose();
    itemNameCtr.dispose();
    // descriptCtr.dispose();
    periodCtr.dispose();

    super.dispose();
  }

  Future<void> onSave() async {
    alarmTime = openTime?.add(Duration(seconds: itemAlarm!.validityPeriod!));
    if (expireTime != null && alarmTime!.isAfter(expireTime!)) {
      alarmTime = expireTime!.add(const Duration(seconds: 86400));
    }

    // if ((itemAlarm?.alarmTime)!.difference(alarmTime!) == Duration(seconds: 0)) {
    //   Get.back();
    //   return;
    // }

    itemAlarm?.alarmTime = alarmTime;

    await _alarmDbMgr.updateItemAlarm(itemAlarm!);

    // Get.off(() => const AlarmListPage());
    Get.offAll(() => IndexPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: ImageIcon(ViewUtils.getAssetImage('icon_activity_back')),
            color: Colors.black,
            onPressed: () {
              Get.to(() => IndexPage(
                    tindex: 0,
                  ));
            }),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '更新闹钟',
          style: TextStyle(fontSize: 18.sp, color: const Color(0xFF222222), fontWeight: FontWeight.bold),
        ),
      ),
      body: _build(context),
    );
  }

  ///定义异步寄存器
  final AsyncMemoizer _memoization = AsyncMemoizer<dynamic>();

  FutureBuilder<dynamic> _build(BuildContext context) {
    return FutureBuilder<dynamic>(
      //future：这个参数需要一个Future 对象，类似于 网络请求、IO
      future: _memoization.runOnce(loadData),

      ///构建显示的 Widget  会根据加载的状态来多次回调些方法
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        //加载状态判断
        switch (snapshot.connectionState) {

          ///可理解为初始加载显示的 Widget 异步加载开始时的回调
          case ConnectionState.none:
            return Text('Result: ${snapshot.data}');

          ///异步加载中的回调
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();

          ///异步加载完成的回调
          case ConnectionState.done:
            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: '条形码 ',
                                style: TextStyle(color: const Color(0xFF2E2E2E), fontSize: 15.sp),
                                // children: [TextSpan(text: '*', style: TextStyle(fontSize: 16.sp, color: Colors.red))]
                                ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          SizedBox(
                            width: 1.w,
                            height: 28.5.h,
                            child: Container(
                              color: const Color(0xFFDEDEDE),
                            ),
                          ),
                          Expanded(
                              child: TextField(
                            controller: barcodeCtr,
                            readOnly: true,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                contentPadding: EdgeInsets.only(left: 10.w),
                                border: InputBorder.none),
                          )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: '名   称 ',
                                style: TextStyle(color: const Color(0xFF2E2E2E), fontSize: 15.sp),
                                children: [TextSpan(text: '*', style: TextStyle(fontSize: 16.sp, color: Colors.red))]),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          SizedBox(
                            width: 1.w,
                            height: 28.5.h,
                            child: Container(
                              color: const Color(0xFFDEDEDE),
                            ),
                          ),
                          Expanded(
                              child: TextField(
                            controller: itemNameCtr,
                            readOnly: true,
                            decoration: InputDecoration(
                                hintText: '请输入物品名称',
                                hintStyle: TextStyle(
                                    color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                contentPadding: EdgeInsets.only(left: 10.w),
                                border: InputBorder.none),
                          )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: '保质期  ',
                                style: TextStyle(color: const Color(0xFF2E2E2E), fontSize: 15.sp),
                                children: [TextSpan(text: '', style: TextStyle(fontSize: 16.sp, color: Colors.red))]),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          SizedBox(
                            width: 1.w,
                            height: 28.5.h,
                            child: Container(
                              color: const Color(0xFFDEDEDE),
                            ),
                          ),
                          Expanded(
                              child: TextField(
                            controller: periodCtr,
                            decoration: InputDecoration(
                                hintText: '请输入数字',
                                hintStyle: TextStyle(
                                    color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                contentPadding: EdgeInsets.only(left: 10.w),
                                border: InputBorder.none),
                            //只允许输入小数
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                            ],
                            //键盘类型
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          )),
                          Container(
                              margin: EdgeInsets.only(left: 10.w),
                              child: DropdownButton<String>(
                                value: ptypes[ptype],
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  if (mounted) {
                                    setState(() {
                                      ptype = ptypes.indexOf(newValue!);
                                    });
                                  }
                                },
                                items: ptypes.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 15.w,
                      ),
                      _showOpenWidget(),
                      SizedBox(
                        height: 15.w,
                      ),
                      // Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       RichText(
                      //         text: TextSpan(
                      //           text: '物品描述 ',
                      //           style: TextStyle(color: const Color(0xFF2E2E2E), fontSize: 15.sp),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 5.w,
                      //       ),
                      //       _textField('描述', descriptCtr),
                      //     ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              // elevation: 5.0,
                              child: const Text('确定'),
                              onPressed: () => onSave(),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(30.0)),
                            ),
                            ElevatedButton(
                              // elevation: 5.0,
                              child: const Text('取消'),
                              onPressed: () {
                                Get.back();
                                // Get.to(() => IndexPage());
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 208, 207, 207),
                                textStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                elevation: 0,
                              ),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(30.0)),
                            ),
                          ])
                    ],
                  ),
                ),
              ],
            );
        }
      },
    );
  }

  Widget _showOpenWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SizedBox(
        //   width: 15.w,
        //   height: 70.h,
        // ),
        RichText(
          text: TextSpan(
              text: '开封日期  ',
              style: TextStyle(color: const Color(0xFF2E2E2E), fontSize: 15.sp),
              children: [TextSpan(text: '', style: TextStyle(fontSize: 16.sp, color: Colors.red))]),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
            child: GestureDetector(
          child: Container(
            margin: EdgeInsets.only(right: 15.w),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  openTime == null ? '选择时间' : DateUtil.getFormatTime5(openTime!),
                  style: openTime == null
                      ? TextStyle(fontSize: 15.sp, color: const Color(0xFF969696))
                      : TextStyle(fontSize: 15.sp, color: const Color(0xFF2E2E2E), fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10.w,
                ),
                ViewUtils.getImage('icon_active_more', 14.w, 14.w),
              ],
            ),
          ),
          onTap: () => _showCupertinoDatePicker(),
        )),
      ],
    );
  }

  void _showCupertinoDatePicker() {
    DateTime initialDateTime = openTime!; //DateTime.now();
    int initialMinute = initialDateTime.minute;
    int minInterval = 5;
    if (initialDateTime.minute % minInterval != 0) {
      initialMinute = initialDateTime.minute - initialDateTime.minute % minInterval + minInterval;
    } else {
      initialMinute += minInterval;
    }

    _showPickerView(CupertinoDatePicker(
        use24hFormat: true,
        mode: CupertinoDatePickerMode.dateAndTime,
        //这里改模式
        minuteInterval: minInterval,
        maximumYear: DateTime.now().year + 1,
        minimumYear: DateTime.now().year,
        // minimumDate: isStartTime ? DateTime.now() : startTime!,
        initialDateTime: DateTime(
            initialDateTime.year, initialDateTime.month, initialDateTime.day, initialDateTime.hour, initialMinute),
        onDateTimeChanged: (dateTime) {
          openTime = dateTime;
          setState(() {});
        }));
  }

  void _showPickerView(Widget child) {
    Get.bottomSheet(
        Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    openTime ??= DateTime.now();
                    setState(() {});
                    Get.back();
                  },
                  child: Text(
                    '确认',
                    style: TextStyle(fontSize: 13.sp),
                  )),
            ],
          ),
          SizedBox(
            height: ScreenUtil().screenHeight.h / 3,
            child: child,
          ),
        ]),
        backgroundColor: Colors.white);
  }
}
