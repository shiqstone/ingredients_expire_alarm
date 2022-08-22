import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/db/alarm_db_manage.dart';
import 'package:ingredients_expire_alarm/db/item_db_manage.dart';
import 'package:ingredients_expire_alarm/model/item_alarm.dart';
import 'package:ingredients_expire_alarm/model/item_record.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/csv_util.dart';
import 'package:ingredients_expire_alarm/util/file_util.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';
import 'package:path_provider/path_provider.dart';

class BackupPage extends StatelessWidget {
  BackupPage({Key? key}) : super(key: key);

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
        '备份管理',
        style: TextStyle(fontSize: 18, color: Color(0xFF1E1E1E), fontWeight: FontWeight.bold),
      ),
      elevation: 0.5,
      centerTitle: true,
    );
  }

  Widget _buildItem(String title, GestureTapCallback onTap, {bool showDivider = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 56.w,
            color: Colors.white,
            child: Row(
              children: [
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
                Container(
                  margin: EdgeInsets.only(left: 5.0.w, right: 16.w),
                  child: ViewUtils.getImage(
                    "icon_active_more",
                    8.w,
                    12.h,
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
        children: [
          // _buildItem('导出物品', () => exportItems()),
          // _buildItem('导出定时', () => exportAlarms()),
          _buildItem('导出', () => exportAll()),
          _buildItem('导入', () => import())
        ],
      ),
    );
  }

  Widget buildRadiusView(Widget child, double radius) {
    return ClipRRect(
      child: child,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  final ItemDbManage _itemDbManage = ItemDbManage();
  final AlarmDbManage _alarmDbManage = AlarmDbManage();
  Future<bool?> exportItems() async {
    List<Map<String, dynamic>> list = await _itemDbManage.getItemRecordMapList();
    var content = mapListToCsv(list);
    if (content != null && content.isNotEmpty) {
      return saveFile('exp_items.csv', content);
    }
    return null;
  }

  Future<bool?> exportAlarms() async {
    int? status;
    List<Map<String, dynamic>> list = await _alarmDbManage.getItemAlarmMapList(status);
    var content = mapListToCsv(list);
    if (content != null && content.isNotEmpty) {
      return saveFile('exp_alarms.csv', content);
    }
    return null;
  }

  Future<bool?> exportAll() async {
    bool? res;
    res = await exportItems();
    res = res != null ? await exportAlarms() : res;
    return res;
  }

  Future<void> import() async {
    var esdir = await getExternalStorageDirectory();
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv'], initialDirectory: esdir!.path);

    if (result != null) {
      File file = File(result.files.single.path!);
      final contents = await file.readAsString();
      List<Map<String, Object?>>? list = csvToMapList(contents);
      if (list != null && list.isNotEmpty) {
        for (var item in list) {
          if (result.files.single.name == 'exp_items.csv') {
            importItem(item);
          } else if (result.files.single.name == 'exp_alarms.csv') {
            importAlarm(item);
          }
        }
      }
      ToastUtil.show('导入成功');
    } else {
      // User canceled the picker
    }
  }

  Future<void> importItem(Map<String, Object?> item) async {
    int id = int.parse(item['id'].toString());
    var itemRecord = await _itemDbManage.getItemById(id);
    if (itemRecord == null) {
      _itemDbManage.insertItemRecord(ItemRecord.fromMapObject(item));
    }
  }

  Future<void> importAlarm(Map<String, Object?> item) async {
    int id = int.parse(item['id'].toString());
    var itemRecord = await _alarmDbManage.getItemById(id);
    if (itemRecord == null) {
      _alarmDbManage.insertItemAlarm(ItemAlarm.fromMapObject(item));
    }
  }
}
