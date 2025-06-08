import 'package:Tosell/Features/auth/models/Role.dart';
import 'package:Tosell/Features/profile/models/zone.dart';

class User {
  String? token;
  String? fullName;
  String? userName;
  String? phoneNumber;
  String? img;
  Role? role;
  Zone? zone;
  Null branch;
  String? type;
  String? id;
  bool? deleted;
  String? creationDate;

  User(
      {this.token,
      this.fullName,
      this.userName,
      this.phoneNumber,
      this.img,
      this.role,
      this.zone,
      this.branch,
      this.type,
      this.id,
      this.deleted,
      this.creationDate});

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    fullName = json['fullName'];
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    branch = json['branch'];
    type = json['type'];
    id = json['id'];
    deleted = json['deleted'];
    creationDate = json['creationDate'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['phoneNumber'] = this.phoneNumber;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    data['zone'] = this.zone;
    data['branch'] = this.branch;
    data['type'] = this.type;
    data['id'] = this.id;
    data['deleted'] = this.deleted;
    data['creationDate'] = this.creationDate;
    data['creationDate'] = this.creationDate;
    data['img'] = this.img;
    return data;
  }
}
