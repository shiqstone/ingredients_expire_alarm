class HomeItemAlarm {
  int? id;
  int? barcode;
  String? name;
  int? batCount;
  String? batUnit;
  String? description;
  int? validityPeriod;
  DateTime? expireDate;
  DateTime? alarmTime;
  int? status;

  HomeItemAlarm(
      {this.id,
      this.barcode,
      this.name,
      this.batCount,
      this.batUnit,
      this.description,
      this.validityPeriod,
      this.expireDate,
      this.alarmTime,
      this.status = 1});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'batCount': batCount,
      'batUnit': batUnit,
      'description': description,
      'validityPeriod': validityPeriod,
      'expireDate': expireDate?.millisecondsSinceEpoch,
      'alarmTime': alarmTime?.millisecondsSinceEpoch,
      'status': status,
    };
  }

  HomeItemAlarm.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    barcode = map['barcode'];
    name = map['name'];
    batCount = map['batCount'];
    batUnit = map['batUnit'];
    description = map['description'];
    validityPeriod = map['validityPeriod'];
    if (map['expireDate'] != null) {
      expireDate = DateTime.fromMillisecondsSinceEpoch(map['expireDate']);
    }
    alarmTime = DateTime.fromMillisecondsSinceEpoch(map['alarmTime']);
    status = map['status'];
  }
}

enum AlarmStatus { normal, disable }
