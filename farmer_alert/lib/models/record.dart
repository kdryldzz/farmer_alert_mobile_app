class Record {
  int? id;
  String action;
  String crop;
  double cost;
  String date;

  Record({
    this.id,
    required this.action,
    required this.crop,
    required this.cost,
    required this.date,
  });

  // Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'crop': crop,
      'cost': cost,
      'date': date,
    };
  }

  // Map'ten nesne oluşturma
  static Record fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      action: map['action'],
      crop: map['crop'],
      cost: map['cost'],
      date: map['date'],
    );
  }
}
