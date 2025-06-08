class Role {
  String? name;
  String? id;
  bool? deleted;
  String? creationDate;

  Role({this.name, this.id, this.deleted, this.creationDate});

  Role.fromJson(Map<String, dynamic> json) {
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