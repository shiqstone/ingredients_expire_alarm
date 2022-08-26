import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/db/home_alarm_db_manage.dart';
import 'package:ingredients_expire_alarm/model/home_item_alarm.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/date_util.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';

import 'package:async/async.dart' show AsyncMemoizer;

import 'item_list_page.dart';
import 'widget/calendar_widget.dart';

class AddHomeAlarmRecordPage extends StatefulWidget {
  final String? barcode;
  const AddHomeAlarmRecordPage({Key? key, this.barcode}) : super(key: key);

  @override
  _AddHomeAlarmRecordPageState createState() => _AddHomeAlarmRecordPageState();
}

class _AddHomeAlarmRecordPageState extends State<AddHomeAlarmRecordPage> {
  late var barcodeCtr = TextEditingController();
  late var itemNameCtr = TextEditingController();
  late var descriptCtr = TextEditingController();
  var ptypes = ['小时', '天', '月'];
  int ptype = 1;
  late var periodCtr = TextEditingController();
  DateTime? expireTime;
  DateTime? productTime;

  bool? bcMode;
  HomeItemAlarm? item;

  int? validityPeriod;

  late var batCountCtr = TextEditingController();
  late var batUnitCtr = TextEditingController();
  int? batCount;
  String? batUnit;

  final HomeAlarmDbManage _alarmDbMgr = HomeAlarmDbManage();

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData() async {
    if (widget.barcode != null && widget.barcode!.isNotEmpty) {
      bcMode = true;
      barcodeCtr = TextEditingController(text: widget.barcode!.toString());
      var ilist = await _alarmDbMgr.getItemByBarcode(widget.barcode!);
      if (ilist.isNotEmpty) {
        var hia = ilist[0];
        itemNameCtr = TextEditingController(text: hia.name);
        descriptCtr = TextEditingController(text: hia.description);

        if (hia.validityPeriod != null) {
          validityPeriod = hia.validityPeriod;

          int period = 0;
          if ((validityPeriod)! > 86400 * 30) {
            ptype = 2;
            period = ((validityPeriod)! / 86400 / 30).round();
          } else if ((validityPeriod)! > 86400) {
            ptype = 1;
            period = ((validityPeriod)! / 86400).round();
          } else {
            ptype = 0;
            period = ((validityPeriod)! / 3600).round();
          }
          periodCtr = TextEditingController(text: period.toString());
        }
      }
    } else {
      bcMode = false;
    }
  }

  @override
  void dispose() {
    barcodeCtr.dispose();
    itemNameCtr.dispose();
    descriptCtr.dispose();
    periodCtr.dispose();
    batCountCtr.dispose();
    batUnitCtr.dispose();

    super.dispose();
  }

  Future<void> onChanged() async {
    int period = int.parse(periodCtr.text);
    if (ptype == 0) {
      validityPeriod = period * 3600;
    } else if (ptype == 1) {
      validityPeriod = period * 86400;
    } else if (ptype == 2) {
      validityPeriod = period * 86400 * 30;
    }

    if (productTime != null && validityPeriod != null && validityPeriod! > 0) {
      expireTime = productTime!.add(Duration(seconds: validityPeriod!));
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> onAdd() async {
    if (expireTime == null) {
      _showSnackBar(context, '请选择过期时间');
      return;
    }

    DateTime alarmTime = expireTime!;

    final HomeItemAlarm itemAlarm;
    if (bcMode!) {
      itemAlarm = HomeItemAlarm(
        barcode: int.parse(barcodeCtr.text),
        name: itemNameCtr.text,
        description: descriptCtr.text,
        validityPeriod: validityPeriod,
        expireDate: expireTime,
        alarmTime: alarmTime,
      );
    } else {
      itemAlarm = HomeItemAlarm(
        name: itemNameCtr.text,
        description: descriptCtr.text,
        validityPeriod: validityPeriod,
        expireDate: expireTime,
        alarmTime: alarmTime,
      );
    }

    await _alarmDbMgr.insertHomeItemAlarm(itemAlarm);

    Get.offAll(() => const HomeAlarmListPage());
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
          Get.offAll(() => const HomeAlarmListPage());
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: ImageIcon(ViewUtils.getAssetImage('icon_activity_back')),
                color: Colors.black,
                onPressed: () {
                  Get.offAll(() => const HomeAlarmListPage());
                }),
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              '添加闹钟',
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
                              child: TextField(
                            controller: itemNameCtr,
                            decoration: InputDecoration(
                                hintText: '请输入物品名称',
                                hintStyle: TextStyle(
                                    color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                contentPadding: EdgeInsets.only(left: 10.w),
                                border: InputBorder.none),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 15.w,
                      ),
                      _showProductionWidget(),
                      SizedBox(
                        height: 15.w,
                      ),
                      _validityPeriodWidget(),
                      SizedBox(
                        height: 15.w,
                      ),
                      _showExpireWidget(),
                      SizedBox(
                        height: 15.w,
                      ),
                      _batCountWidget(),
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
                            ),
                            ElevatedButton(
                              // elevation: 5.0,
                              child: const Text('取消'),
                              onPressed: () {
                                Get.offAll(() => const HomeAlarmListPage());
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 208, 207, 207),
                                textStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                elevation: 0,
                              ),
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
        border: Border.all(color: themeColor.primaryColor, width: 1.w),
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
        maxLength: 500,
        cursorWidth: 2,
        // showCursor: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
          border: InputBorder.none,
          isCollapsed: false,
          counterStyle: TextStyle(color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _validityPeriodWidget() {
    return Row(
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
              hintStyle: TextStyle(color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
              contentPadding: EdgeInsets.only(left: 10.w),
              border: InputBorder.none),
          //只允许输入小数
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
          ],
          //键盘类型
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (String? newValue) {
            onChanged();
          },
        )),
        Container(
            margin: EdgeInsets.only(left: 10.w, right: 15.w),
            child: DropdownButton<String>(
              value: ptypes[ptype],
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              onChanged: (String? newValue) {
                if (mounted) {
                  setState(() {
                    ptype = ptypes.indexOf(newValue!);
                  });
                  onChanged();
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
    );
  }

  Widget _showProductionWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: '生产日期',
            style: TextStyle(color: const Color(0xFF2E2E2E), fontSize: 15.sp),
            // children: [TextSpan(text: '', style: TextStyle(fontSize: 16.sp, color: Colors.red))]
          ),
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
                        productTime == null ? '选择时间' : DateUtil.getFormatDate(productTime!),
                        style: productTime == null
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
                      showTime: productTime,
                      title: '选择生产日期',
                    ),
                    fullscreenDialog: false,
                  )!
                      .then((value) => {
                            // print(value),
                            if (value != null)
                              {
                                productTime = value,
                                onChanged(),
                              },
                            if (mounted) {setState(() {})}
                          });
                })),
      ],
    );
  }

  Widget _showExpireWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
              text: '过期日期',
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
                      showTime: expireTime,
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

  Widget _batCountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
              text: '数    量 ',
              style: TextStyle(color: const Color(0xFF2E2E2E), fontSize: 15.sp),
              // children: [TextSpan(text: '', style: TextStyle(fontSize: 16.sp, color: Colors.red))]
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
          controller: batCountCtr,
          decoration: InputDecoration(
              hintText: '请输入数量',
              hintStyle: TextStyle(color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
              contentPadding: EdgeInsets.only(left: 10.w),
              border: InputBorder.none),
          //只允许输入小数
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
          ],
          //键盘类型
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        )),
        Expanded(
            child: TextField(
          controller: batUnitCtr,
          decoration: InputDecoration(
              hintText: '单位',
              hintStyle: TextStyle(color: themeColor.titleLightColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
              contentPadding: EdgeInsets.only(left: 10.w),
              border: InputBorder.none),
        )),
      ],
    );
  }
}
