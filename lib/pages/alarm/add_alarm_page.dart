import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/db/alarm_db_manage.dart';
import 'package:ingredients_expire_alarm/db/item_db_manage.dart';
import 'package:ingredients_expire_alarm/model/item_alarm.dart';
import 'package:ingredients_expire_alarm/model/item_record.dart';
import 'package:ingredients_expire_alarm/pages/settings/add_item_page.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/date_util.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';

import 'package:async/async.dart' show AsyncMemoizer;

import 'widget/calendar_widget.dart';

class AddAlarmRecordPage extends StatefulWidget {
  final String? barcode;
  const AddAlarmRecordPage({Key? key, this.barcode}) : super(key: key);

  @override
  _AddAlarmRecordPageState createState() => _AddAlarmRecordPageState();
}

class _AddAlarmRecordPageState extends State<AddAlarmRecordPage> {
  late var barcodeCtr = TextEditingController();
  late var itemNameCtr = TextEditingController();
  late var descriptCtr = TextEditingController();
  var ptypes = ['小时', '天', '月'];
  int ptype = 0;
  late var periodCtr = TextEditingController();
  DateTime? expireTime;

  bool? bcMode;
  ItemRecord? item;
  Map<int, String> itemMap = {};
  List<DropdownMenuItem<int>> itemOpt = [];
  int? optId;

  final AlarmDbManage _alarmDbMgr = AlarmDbManage();
  final ItemDbManage _itemDbMgr = ItemDbManage();

  @override
  void initState() {
    super.initState();
    // initCtr();
  }

  Future<void> loadData() async {
    if (widget.barcode != null && widget.barcode!.isNotEmpty) {
      bcMode = true;
      item = await _itemDbMgr.getItemByBarcode(widget.barcode!);
    } else {
      bcMode = false;
      var ilist = await _itemDbMgr.getItemRecordList();
      for (var rec in ilist) {
        if (rec.barcode != null) {
          continue;
        }
        itemMap[rec.id!] = rec.name!;
        itemOpt.add(DropdownMenuItem(
          value: rec.id!,
          child: Text(rec.name!),
        ));
      }
    }

    if (bcMode!) {
      if (item == null) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Get.defaultDialog(
              content: const Text('是否添加？'),
              title: '物品未入库',
              onConfirm: () {
                Get.to(() => AddItemRecordPage(barcode: widget.barcode));
              },
              onCancel: () {
                // Get.back(closeOverlays: true);
                Get.offAll(() => IndexPage());
              },
              textConfirm: '是',
              confirmTextColor: Colors.white,
              textCancel: '否',
              cancelTextColor: Colors.black);
        });
      } else {
        barcodeCtr = TextEditingController(text: item?.barcode!.toString());
        itemNameCtr = TextEditingController(text: item?.name);
        descriptCtr = TextEditingController(text: item?.description);

        int period = 0;
        if ((item?.validityPeriod)! > 86400 * 30) {
          ptype = 2;
          period = ((item?.validityPeriod)! / 86400 / 30).round();
        } else if ((item?.validityPeriod)! > 86400) {
          ptype = 1;
          period = ((item?.validityPeriod)! / 86400).round();
        } else {
          ptype = 0;
          period = ((item?.validityPeriod)! / 3600).round();
        }
        periodCtr = TextEditingController(text: period.toString());
      }
    } else {
      if (optId != null) {
        item = await _itemDbMgr.getItemById(optId!);

        itemNameCtr = TextEditingController(text: item?.name);
        descriptCtr = TextEditingController(text: item?.description);

        int period = 0;
        if ((item?.validityPeriod)! > 86400 * 30) {
          ptype = 2;
          period = ((item?.validityPeriod)! / 86400 / 30).round();
        } else if ((item?.validityPeriod)! > 86400) {
          ptype = 1;
          period = ((item?.validityPeriod)! / 86400).round();
        } else {
          ptype = 0;
          period = ((item?.validityPeriod)! / 3600).round();
        }
        periodCtr = TextEditingController(text: period.toString());
      }
    }
  }

  Future<void> onChanged() async {
    if (optId != null) {
      item = await _itemDbMgr.getItemById(optId!);

      itemNameCtr = TextEditingController(text: item?.name);
      descriptCtr = TextEditingController(text: item?.description);

      int period = 0;
      if ((item?.validityPeriod)! > 86400 * 30) {
        ptype = 2;
        period = ((item?.validityPeriod)! / 86400 / 30).round();
      } else if ((item?.validityPeriod)! > 86400) {
        ptype = 1;
        period = ((item?.validityPeriod)! / 86400).round();
      } else {
        ptype = 0;
        period = ((item?.validityPeriod)! / 3600).round();
      }
      periodCtr = TextEditingController(text: period.toString());
    }
  }

  @override
  void dispose() {
    barcodeCtr.dispose();
    itemNameCtr.dispose();
    descriptCtr.dispose();
    periodCtr.dispose();

    super.dispose();
  }

  Future<void> onAdd() async {
    if ((item?.validityPeriod)! > 86400 * 2 && expireTime == null) {
      _showSnackBar(context, '请选择过期时间');
      return;
    }

    DateTime alarmTime = DateTime.now();
    alarmTime = alarmTime.add(Duration(seconds: item!.validityPeriod!));
    if (expireTime != null && alarmTime.isAfter(expireTime!)) {
      alarmTime = expireTime!.add(const Duration(seconds: 86400));
    }

    final ItemAlarm itemAlarm;
    if (bcMode!) {
      List<ItemAlarm?> list = await _alarmDbMgr.getItemByBarcode(widget.barcode!);
      for (var item in list) {
        item!.status = 0;
        await _alarmDbMgr.updateItemAlarm(item);
      }

      itemAlarm = ItemAlarm(
        barcode: int.parse(barcodeCtr.text),
        name: itemNameCtr.text,
        validityPeriod: item!.validityPeriod,
        expireDate: expireTime,
        alarmTime: alarmTime,
      );
    } else {
      List<ItemAlarm?> list = await _alarmDbMgr.getItemsByName(itemMap[optId]!);
      for (var item in list) {
        item!.status = 0;
        await _alarmDbMgr.updateItemAlarm(item);
      }

      itemAlarm = ItemAlarm(
        name: itemNameCtr.text,
        validityPeriod: item!.validityPeriod,
        expireDate: expireTime,
        alarmTime: alarmTime,
      );
    }

    await _alarmDbMgr.insertItemAlarm(itemAlarm);

    // Get.off(() => const AlarmListPage());
    Get.offAll(() => IndexPage());
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 500),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      margin: EdgeInsets.fromLTRB(20, 0, 20, (ScreenUtil.defaultSize.height / 2)),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.to(() => IndexPage());
          return true;
        },
        child: Scaffold(
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
        ));
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
                      Visibility(
                        visible: bcMode!,
                        child: Row(
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
                            child: bcMode!
                                ? TextField(
                                    controller: itemNameCtr,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        hintText: '请输入物品名称',
                                        hintStyle: TextStyle(
                                            color: themeColor.titleLightColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600),
                                        contentPadding: EdgeInsets.only(left: 10.w),
                                        border: InputBorder.none),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(left: 10.w, right: 5.w),
                                    child: DropdownButton<int>(
                                      value: optId,
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      isExpanded: true,
                                      hint: Text('请选择物品',
                                          style: TextStyle(
                                            color: themeColor.titleLightColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      onChanged: (int? newValue) {
                                        if (mounted) {
                                          setState(() {
                                            optId = newValue;
                                          });
                                          onChanged();
                                        }
                                      },
                                      items: itemOpt,
                                    )),
                          ),
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
                      Visibility(
                          visible: (item != null && item!.validityPeriod! > 172800), //判断有效期大于48小时
                          child: _showExpireWidget()),
                      SizedBox(
                        height: 15.w,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '物品描述 ',
                                style: TextStyle(color: const Color(0xFF2E2E2E), fontSize: 15.sp),
                              ),
                            ),
                            SizedBox(
                              height: 5.w,
                            ),
                            _textField('描述', descriptCtr),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              // elevation: 5.0,
                              child: const Text('确定'),
                              onPressed: () => onAdd(),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(30.0)),
                            ),
                            ElevatedButton(
                              // elevation: 5.0,
                              child: const Text('取消'),
                              onPressed: () {
                                Get.to(() => IndexPage());
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

  _textField(String label, TextEditingController _controller) {
    return Container(
      margin: EdgeInsets.all(6.w).copyWith(bottom: 32.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        // color: themeColor.primaryColor,
        borderRadius: BorderRadius.circular(18.w),
        // border: Border.all(color: themeColor.primaryColor, width: 1.w),
      ),
      height: 125.w,
      child: TextFormField(
        style: TextStyle(height: 1.5, fontSize: 15.sp),
        maxLines: null,
        // inputFormatters: [
        //   LengthLimitingTextInputFormatter(500) //限制长度
        // ],
        onChanged: (String value) {},
        controller: _controller,
        scrollPadding: EdgeInsets.zero,
        keyboardType: TextInputType.multiline,
        cursorColor: themeColor.primaryColor,
        cursorHeight: 16.sp,
        // maxLength: 500,
        cursorWidth: 2,
        // showCursor: true,
        decoration: InputDecoration(
          // labelText: label,
          // labelStyle: TextStyle(color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
          border: InputBorder.none,
          isCollapsed: false,
          counterStyle: TextStyle(color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _showExpireWidget() {
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
              text: '过期日期  ',
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
                        expireTime == null ? '选择时间' : DateUtil.getFormatDate(expireTime!),
                        style: expireTime == null
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
                onTap: () async {
                  Get.to(
                    () => CalendarWidget(
                      expireTime: expireTime,
                      title: '选择过期日期',
                    ),
                    fullscreenDialog: false,
                  )!
                      .then((value) => {
                            // print(value),
                            if (value != null)
                              {
                                expireTime = value,
                              },
                            if (mounted) {setState(() {})}
                          });
                })),
      ],
    );
  }
}
