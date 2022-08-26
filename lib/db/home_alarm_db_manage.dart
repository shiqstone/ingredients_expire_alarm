import 'dart:async';
import 'package:ingredients_expire_alarm/model/home_item_alarm.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HomeAlarmDbManage {
  static Database? _database;

  String itemsTable = 'home_item_alarm';

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
        'CREATE TABLE `home_item_alarm` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `barcode` int, `name` text, `batCount` int, `batUnit` text, `validityPeriod` int, `description` text, `expireDate` int, `alarmTime` int, `status` tinyint);');
  }

  //  读取数据
  Future<List<Map<String, dynamic>>> getHomeItemAlarmMapList(int? status) async {
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
  Future<int> insertHomeItemAlarm(HomeItemAlarm itemRecord) async {
    Database db = await database;
    var result = await db.insert(itemsTable, itemRecord.toMap());
    return result;
  }

  //  刷新数据
  Future<int> updateHomeItemAlarm(HomeItemAlarm itemRecord) async {
    Database db = await database;
    var result = await db.update(itemsTable, itemRecord.toMap(), where: 'id = ?', whereArgs: [itemRecord.id]);
    return result;
  }

  Future<List<HomeItemAlarm>> getItemByBarcode(String barcode) async {
    Database db = await database;
    var itemAlarmMapList = await db.query(itemsTable, where: 'barcode = ?', whereArgs: [barcode]);
    int count = itemAlarmMapList.length;
    List<HomeItemAlarm> itemRecordList = [];

    for (int i = 0; i < count; i++) {
      itemRecordList.add(HomeItemAlarm.fromMapObject(itemAlarmMapList[i]));
    }
    return itemRecordList;
  }

  Future<List<HomeItemAlarm>> getItemsByName(String name) async {
    Database db = await database;
    var itemAlarmMapList = await db.query(itemsTable, where: 'name = ?', whereArgs: [name]);
    int count = itemAlarmMapList.length;

    List<HomeItemAlarm> itemRecordList = [];

    for (int i = 0; i < count; i++) {
      itemRecordList.add(HomeItemAlarm.fromMapObject(itemAlarmMapList[i]));
    }
    return itemRecordList;
  }

  //  删除数据
  Future<int> deleteHomeItemAlarm(int id) async {
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
  Future<List<HomeItemAlarm>> getHomeItemAlarmList(int? status) async {
    var itemAlarmMapList = await getHomeItemAlarmMapList(status);
    int count = itemAlarmMapList.length;

    List<HomeItemAlarm> itemRecordList = [];

    for (int i = 0; i < count; i++) {
      itemRecordList.add(HomeItemAlarm.fromMapObject(itemAlarmMapList[i]));
    }
    return itemRecordList;
  }

  Future<HomeItemAlarm?> getItemById(int id) async {
    Database db = await database;
    var result = await db.query(itemsTable, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return HomeItemAlarm.fromMapObject(result[0]);
    } else {
      return null;
    }
  }
}
