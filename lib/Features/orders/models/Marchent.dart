import 'package:Tosell/Features/orders/models/Role.dart';

class Merchant {
  String? brandName;
  String? brandImg;
  String? secondPhoneNumber;
  int? merchantType;
  String? code;
  String? userName;
  String? phoneNumber;
  Role? role;
  String? id;
  bool? deleted;
  String? creationDate;

  Merchant(
      {this.brandName,
      this.brandImg,
      this.secondPhoneNumber,
      this.merchantType,
      this.code,
      this.userName,
      this.phoneNumber,
      this.role,
      this.id,
      this.deleted,
      this.creationDate});

  Merchant.fromJson(Map<String, dynamic> json) {
    brandName = json['brandName'];
    brandImg = json['brandImg'];
    secondPhoneNumber = json['secondPhoneNumber'];
    merchantType = json['merchantType'];
    code = json['code'];
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    id = json['id'];
    deleted = json['deleted'];
    creationDate = json['creationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandName'] = this.brandName;
    data['brandImg'] = this.brandImg;
    data['secondPhoneNumber'] = this.secondPhoneNumber;
    data['merchantType'] = this.merchantType;
    data['code'] = this.code;
    data['userName'] = this.userName;
    data['phoneNumber'] = this.phoneNumber;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    data['id'] = this.id;
    data['deleted'] = this.deleted;
    data['creationDate'] = this.creationDate;
    return data;
  }
}
