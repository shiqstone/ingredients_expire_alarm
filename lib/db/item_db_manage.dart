import 'dart:async';
import 'package:path/path.dart';
import 'package:ingredients_expire_alarm/model/item_record.dart';
import 'package:sqflite/sqflite.dart';

class ItemDbManage {
  // ItemDbManage? _databaseManage;
  static Database? _database;

  String itemsTable = 'item_record';

  // ItemDbManage._createInstance();

  // factory ItemDbManage() {
  //   return ItemDbManage._createInstance();
  //   // _databaseManage ??= ItemDbManage._createInstance();
  //   // return _databaseManage;
  // }

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
        'CREATE TABLE `item_record` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `barcode` int UNIQUE, `name` text, `description` text, `validityPeriod` int, `expireDate` text, `alarmTime` text, `status` tinyint);');
  }

  //  读取数据
  Future<List<Map<String, dynamic>>> getItemRecordMapList() async {
    Database db = await database;
    var result = await db.query(itemsTable);
    return result;
  }

  //  增加数据
  Future<int> insertItemRecord(ItemRecord itemRecord) async {
    Database db = await database;
    var result = await db.insert(itemsTable, itemRecord.toMap());
    return result;
  }

  //  刷新数据
  Future<int> updateItemRecord(ItemRecord itemRecord) async {
    Database db = await database;
    var result = await db.update(itemsTable, itemRecord.toMap(), where: 'id = ?', whereArgs: [itemRecord.id]);
    return result;
  }

  Future<ItemRecord?> getItemById(int id) async {
    Database db = await database;
    var result = await db.query(itemsTable, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return ItemRecord.fromMapObject(result[0]);
    } else {
      return null;
    }
  }

  Future<ItemRecord?> getItemByBarcode(String barcode) async {
    Database db = await database;
    var result = await db.query(itemsTable, where: 'barcode = ?', whereArgs: [barcode]);
    if (result.isNotEmpty) {
      return ItemRecord.fromMapObject(result[0]);
    } else {
      return null;
    }
  }

  //  删除数据
  Future<int> deleteItemRecord(int id) async {
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
  Future<List<ItemRecord>> getItemRecordList() async {
    var itemRecordMapList = await getItemRecordMapList();
    int count = itemRecordMapList.length;

    List<ItemRecord> itemRecordList = [];

    for (int i = 0; i < count; i++) {
      itemRecordList.add(ItemRecord.fromMapObject(itemRecordMapList[i]));
    }
    return itemRecordList;
  }
}
