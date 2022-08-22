import 'package:csv/csv.dart';

/// Convert a map list to csv
String? mapListToCsv(List<Map<String, Object?>>? mapList, {ListToCsvConverter? converter}) {
  if (mapList == null) {
    return null;
  }
  converter ??= const ListToCsvConverter();
  var data = <List>[];
  var keys = <String>[];
  var keyIndexMap = <String, int>{};

  // Add the key and fix previous records
  int addKey(String key) {
    var index = keys.length;
    keyIndexMap[key] = index;
    keys.add(key);
    for (var dataRow in data) {
      dataRow.add(null);
    }
    return index;
  }

  for (var map in mapList) {
    // This list might grow if a new key is found
    var dataRow = List<Object?>.filled(keyIndexMap.length, null);
    // Fix missing key
    map.forEach((key, value) {
      var keyIndex = keyIndexMap[key];
      if (keyIndex == null) {
        // New key is found
        // Add it and fix previous data
        keyIndex = addKey(key);
        // grow our list
        dataRow = List.from(dataRow, growable: true)..add(value);
      } else {
        dataRow[keyIndex] = value;
      }
    });
    data.add(dataRow);
  }
  return converter.convert(<List>[keys, ...data]);
}

List<Map<String, Object?>>? csvToMapList(String? content, {CsvToListConverter? converter, List<String>? keys}) {
  if (content == null || content.isEmpty) {
    return null;
  }
  converter ??= const CsvToListConverter();
  List<List<dynamic>> rowsAsListOfValues = converter.convert(content);

  Map<String, int> keyMap = {};
  if (keys == null) {
    // keys = <String>[];
    for (var i = 0; i < rowsAsListOfValues[0].length; i++) {
      keyMap[rowsAsListOfValues[0][i]] = i;
    }
  } else {
    for (var i = 0; i < rowsAsListOfValues[0].length; i++) {
      String key = rowsAsListOfValues[0][i];
      if (keys.contains(key)) {
        keyMap[key] = i;
      }
    }
  }

  List<Map<String, Object?>> mapList = [];
  for (var i = 1; i < rowsAsListOfValues.length; i++) {
    List<dynamic> items = rowsAsListOfValues[i];
    Map<String, Object> data = {};
    for (var keyItem in keyMap.entries) {
      var key = keyItem.key;
      var idx = keyItem.value;
      data[key] = items[idx];
    }
    mapList.add(data);
  }
  return mapList;
}
