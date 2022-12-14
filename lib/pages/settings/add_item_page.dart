import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/db/item_db_manage.dart';
import 'package:ingredients_expire_alarm/model/item_record.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';

import 'item_list_page.dart';

class AddItemRecordPage extends StatefulWidget {
  final String? barcode;
  const AddItemRecordPage({Key? key, this.barcode}) : super(key: key);

  @override
  _AddItemRecordPageState createState() => _AddItemRecordPageState();
}

class _AddItemRecordPageState extends State<AddItemRecordPage> {
  late var barcodeCtr = TextEditingController();
  final itemNameCtr = TextEditingController();
  final descriptCtr = TextEditingController();
  var ptypes = ['小时', '天', '月'];
  int ptype = 0;
  final periodCtr = TextEditingController();

  final ItemDbManage _databaseManage = ItemDbManage();

  @override
  void initState() {
    super.initState();
    barcodeCtr = TextEditingController(text: widget.barcode);
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
    if (itemNameCtr.text.isEmpty) {
      _showSnackBar(context, "物品名称不能为空");
      return;
    }
    if (periodCtr.text.isEmpty || int.parse(periodCtr.text) <= 0) {
      _showSnackBar(context, "保质期不能为空");
      return;
    }
    List<ItemRecord> rlist = await _databaseManage.getItemsByName(itemNameCtr.text);
    if (rlist.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.defaultDialog(
            content: const Text('是否继续添加？'),
            title: '已存在同名物品',
            onConfirm: () {
              Get.close(0);
            },
            onCancel: () {
              Get.offAll(() => const ItemListPage());
            },
            textConfirm: '是',
            confirmTextColor: Colors.white,
            textCancel: '否',
            cancelTextColor: Colors.black);
      });
    }

    int validityPeriod = 0;
    int period = int.parse(periodCtr.text);
    if (ptype == 0) {
      validityPeriod = period * 3600;
    } else if (ptype == 1) {
      validityPeriod = period * 86400;
    } else if (ptype == 2) {
      validityPeriod = period * 86400 * 30;
    }
    if (itemNameCtr.text.isNotEmpty) {
      final ItemRecord item = ItemRecord(
          name: itemNameCtr.text,
          validityPeriod: validityPeriod,
          description: descriptCtr.text);

      if (barcodeCtr.text.isNotEmpty) {
        item.barcode = int.parse(barcodeCtr.text);
      }

      await _databaseManage.insertItemRecord(item);

      Get.off(() => const ItemListPage());
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
              // Get.to(() => IndexPage(
              //       tindex: 2,
              //     ));
            }),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '添加物品',
          style: TextStyle(fontSize: 18.sp, color: const Color(0xFF222222), fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
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
                  child: const Text('添加'),
                  onPressed: onAdd,
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(30.0)),
                ),
              ],
            ),
          ),
        ],
      ),
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
