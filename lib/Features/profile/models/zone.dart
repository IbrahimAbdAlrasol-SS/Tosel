class ZoneObject {
  Zone? zone;

  ZoneObject({this.zone});

  ZoneObject.fromJson(Map<String, dynamic> json) {
    zone = json['zone'] != null ? new Zone.fromJson(json['zone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.zone != null) {
      data['zone'] = this.zone!.toJson();
    }
    return data;
  }
}

class Zone {
  String? name;
  int? type;
  Governorate? governorate;
  int? id;
  bool? deleted;
  String? creationDate;

  Zone(
      {this.name,
      this.type,
      this.governorate,
      this.id,
      this.deleted,
      this.creationDate});

  Zone.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    governorate = json['governorate'] != null
        ? new Governorate.fromJson(json['governorate'])
        : null;
    id = json['id'];
    deleted = json['deleted'];
    creationDate = json['creationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.governorate != null) {
      data['governorate'] = this.governorate!.toJson();
    }
    data['id'] = this.id;
    data['deleted'] = this.deleted;
    data['creationDate'] = this.creationDate;
    return data;
  }
}

class Governorate {
  String? name;
  int? id;
  bool? deleted;
  String? creationDate;

  Governorate({this.name, this.id, this.deleted, this.creationDate});

  Governorate.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    deleted = json['deleted'];
    creationDate = json['creationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['deleted'] = this.deleted;
    data['creationDate'] = this.creationDate;
    return data;
  }
}
