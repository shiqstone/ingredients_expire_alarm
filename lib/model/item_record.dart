class ItemRecord {
  int? id;
  int? barcode;
  String? name;
  String? description;
  int? validityPeriod;
  int? status;
  
  ItemRecord ({
    this.id,
    this.barcode,
    this.name,
    this.description,
    this.validityPeriod,
    this.status = 1
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'description': description,
      'validityPeriod': validityPeriod,
      'status': status,
    };
  }

  ItemRecord.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    barcode = map['barcode'];
    name = map['name'];
    description = map['description'];
    validityPeriod = map['validityPeriod'];
    status = map['status'];
  }
} 
