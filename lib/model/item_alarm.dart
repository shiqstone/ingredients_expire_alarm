class ItemAlarm {
  int? id;
  int? barcode;
  String? name;
  int? validityPeriod;
  DateTime? expireDate;
  DateTime? alarmTime;
  int? status;
  
  ItemAlarm ({
    this.id,
    this.barcode,
    this.name,
    this.validityPeriod,
    this.expireDate,
    this.alarmTime,
    this.status = 1
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'validityPeriod': validityPeriod,
      'expireDate': expireDate?.millisecondsSinceEpoch,
      'alarmTime': alarmTime?.millisecondsSinceEpoch,
      'status': status,
    };
  }

  ItemAlarm.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    barcode = map['barcode'];
    name = map['name'];
    validityPeriod = map['validityPeriod'];
    if (map['expireDate'] != null) {
      expireDate = DateTime.fromMillisecondsSinceEpoch(map['expireDate']);
    }
    alarmTime = DateTime.fromMillisecondsSinceEpoch(map['alarmTime']);
    status = map['status'];
  }
} 

enum AlarmStatus {normal, disable}