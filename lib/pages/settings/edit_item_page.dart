import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/db/item_db_manage.dart';
import 'package:ingredients_expire_alarm/model/item_record.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';

import 'package:async/async.dart' show AsyncMemoizer;

import 'item_list_page.dart';

class EditItemRecordPage extends StatefulWidget {
  final int id;
  const EditItemRecordPage({Key? key, required this.id}) : super(key: key);

  @override
  _EditItemRecordPageState createState() => _EditItemRecordPageState();
}

class _EditItemRecordPageState extends State<EditItemRecordPage> {
  late var barcodeCtr = TextEditingController();
  late var itemNameCtr = TextEditingController();
  late var descriptCtr = TextEditingController();
  var ptypes = ['小时', '天', '月'];
  int ptype = 0;
  late var periodCtr = TextEditingController();
  ItemRecord? item;

  final ItemDbManage _databaseManage = ItemDbManage();

  @override
  void initState() {
    super.initState();
    // initCtr();
  }

  Future<void> getItemData() async {
    item = await _databaseManage.getItemById(widget.id);
    if (item != null) {
      barcodeCtr = TextEditingController(text: item!.barcode!.toString());
      itemNameCtr = TextEditingController(text: item!.name);
      descriptCtr = TextEditingController(text: item!.description);

      int period = 0;
      if ((item!.validityPeriod)! > 86400 * 30) {
        ptype = 2;
        period = ((item!.validityPeriod)! / 86400 / 30).round();
      } else if ((item!.validityPeriod)! > 86400) {
        ptype = 1;
        period = ((item!.validityPeriod)! / 86400).round();
      } else {
        ptype = 0;
        period = ((item!.validityPeriod)! / 3600).round();
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

  Future<void> onSave() async {
    if (itemNameCtr.text.isEmpty) {
      _showSnackBar(context, "物品名称不能为空");
      return;
    }
    if (periodCtr.text.isEmpty || int.parse(periodCtr.text) <= 0) {
      _showSnackBar(context, "保质期不能为空");
      return;
    }
    if (barcodeCtr.text.isNotEmpty && itemNameCtr.text.isNotEmpty) {
      int validityPeriod = 0;
      int period = int.parse(periodCtr.text);
      if (ptype == 0) {
        validityPeriod = period * 3600;
      } else if (ptype == 1) {
        validityPeriod = period * 86400;
      } else if (ptype == 2) {
        validityPeriod = period * 86400 * 30;
      }
      item!.name =  itemNameCtr.text;
      item!.description = descriptCtr.text;
      item!.validityPeriod = validityPeriod;

      await _databaseManage.updateItemRecord(item!);

      Get.off(() => const ItemListPage());
      // Get.off(() => IndexPage(
      //       tindex: 2,
      //     ));
    }
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: ImageIcon(ViewUtils.getAssetImage('icon_activity_back')),
            color: Colors.black,
            onPressed: () {
              Get.back();
              // Get.off(() => const ItemListPage());
              // Get.to(() => IndexPage(
              //       tindex: 2,
              //     ));
            }),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '编辑物品',
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
      future: _memoization.runOnce(getItemData),

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
                            controller: barcodeCtr,
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
                                // underline: Container(
                                //   height: 2,
                                //   color: Colors.deepPurpleAccent,
                                // ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    ptype = ptypes.indexOf(newValue!);
                                  });
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
                      ElevatedButton(
                        // elevation: 5.0,
                        child: const Text('保存'),
                        onPressed: onSave,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(30.0)),
                      ),
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
}
