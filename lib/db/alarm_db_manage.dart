import 'dart:async';
import 'package:path/path.dart';
import 'package:ingredients_expire_alarm/model/item_alarm.dart';
import 'package:sqflite/sqflite.dart';

class AlarmDbManage {
  static Database? _database;

  String itemsTable = 'item_alarm';

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, itemsTable + '.db');

    var itemsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return itemsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE `item_alarm` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `barcode` int, `name` text, `validityPeriod` int,  `expireDate` int, `alarmTime` int, `status` tinyint);');
  }

  //  读取数据
  Future<List<Map<String, dynamic>>> getItemAlarmMapList(int? status) async {
    Database db = await database;
    var result;
    if (status != null) {
      result = await db.query(itemsTable, where: 'status = ?', whereArgs: [status], orderBy: 'alarmTime ASC');
    } else {
      result = await db.query(itemsTable, orderBy: 'alarmTime DESC');
    }
    return result;
  }

  //  增加数据
  Future<int> insertItemAlarm(ItemAlarm itemRecord) async {
    Database db = await database;
    var result = await db.insert(itemsTable, itemRecord.toMap());
    return result;
  }

  //  刷新数据
  Future<int> updateItemAlarm(ItemAlarm itemRecord) async {
    Database db = await database;
    var result = await db.update(itemsTable, itemRecord.toMap(), where: 'id = ?', whereArgs: [itemRecord.id]);
    return result;
  }

  Future<List<ItemAlarm>> getItemByBarcode(String barcode) async {
    Database db = await database;
    var itemAlarmMapList = await db.query(itemsTable, where: 'barcode = ?', whereArgs: [barcode]);
    int count = itemAlarmMapList.length;
    List<ItemAlarm> itemRecordList = [];

    for (int i = 0; i < count; i++) {
      itemRecordList.add(ItemAlarm.fromMapObject(itemAlarmMapList[i]));
    }
    return itemRecordList;
  }

  //  删除数据
  Future<int> deleteItemAlarm(int id) async {
    Database db = await database;
    int result = await db.rawDelete('DELETE FROM $itemsTable WHERE id = $id');
    return result;
  }

  //  获取数据条数
  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $itemsTable');
    int? result = Sqflite.firstIntValue(x);
    return result ?? 0;
  }

  // 转化获得 List 类型数据
  Future<List<ItemAlarm>> getItemAlarmList(int? status) async {
    var itemAlarmMapList = await getItemAlarmMapList(status);
    int count = itemAlarmMapList.length;

    List<ItemAlarm> itemRecordList = [];

    for (int i = 0; i < count; i++) {
      itemRecordList.add(ItemAlarm.fromMapObject(itemAlarmMapList[i]));
    }
    return itemRecordList;
  }

  Future<ItemAlarm?> getItemById(int id) async {
    Database db = await database;
    var result = await db.query(itemsTable, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return ItemAlarm.fromMapObject(result[0]);
    } else {
      return null;
    }
  }
}
