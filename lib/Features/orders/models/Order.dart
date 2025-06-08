import 'package:Tosell/Features/orders/models/Marchent.dart';
import 'package:Tosell/Features/profile/models/zone.dart';

class Order {
  String? code;
  String? customerName;
  String? customerPhoneNumber;
  Zone? pickupZone;
  Zone? deliveryZone;
  int? status;
  String? content;
  // List<Null>? statusHistories;
  Merchant? merchant;
  // Null? pickupDelegate;
  // Null? deliveryDelegate;
  // Null? pickupDelegateAssignedAt;
  // Null? pickedUpAt;
  // Null? deliveryDelegateAssignedAt;
  // Null? deliveryStartedAt;
  // Null? deliveredToCustomerAt;
  // String? deliveredToWarehouseAt;
  double? amount;
  int? size;
  bool? isPaid;
  int? priority;
  bool? partialDelivery;
  // List<Null>? additionalExpenses;
  String? id;
  bool? deleted;
  String? creationDate;

  Order(
      {this.code,
      this.customerName,
      this.customerPhoneNumber,
      this.pickupZone,
      this.deliveryZone,
      this.status,
      this.content,
      // this.statusHistories,
      this.merchant,
      // this.pickupDelegate,
      // this.deliveryDelegate,
      // this.pickupDelegateAssignedAt,
      // this.pickedUpAt,
      // this.deliveryDelegateAssignedAt,
      // this.deliveryStartedAt,
      // this.deliveredToCustomerAt,
      // this.deliveredToWarehouseAt,
      this.amount,
      this.size,
      this.isPaid,
      this.priority,
      this.partialDelivery,
      // this.additionalExpenses,
      this.id,
      this.deleted,
      this.creationDate});

  Order.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    customerName = json['customerName'];
    customerPhoneNumber = json['customerPhoneNumber'];
    pickupZone =
        json['pickupZone'] != null ? Zone.fromJson(json['pickupZone']) : null;
    deliveryZone = json['deliveryZone'] != null
        ? Zone.fromJson(json['deliveryZone'])
        : null;
    status = json['status'];
    content = json['content'];
    // if (json['statusHistories'] != null) {
    //   statusHistories = <Null>[];
    //   json['statusHistories'].forEach((v) {
    //     statusHistories!.add(new Null.fromJson(v));
    //   });
    // }
    merchant =
        json['merchant'] != null ? Merchant.fromJson(json['merchant']) : null;
    // pickupDelegate = json['pickupDelegate'];
    // deliveryDelegate = json['deliveryDelegate'];
    // pickupDelegateAssignedAt = json['pickupDelegateAssignedAt'];
    // pickedUpAt = json['pickedUpAt'];
    // deliveryDelegateAssignedAt = json['deliveryDelegateAssignedAt'];
    // deliveryStartedAt = json['deliveryStartedAt'];
    // deliveredToCustomerAt = json['deliveredToCustomerAt'];
    // deliveredToWarehouseAt = json['deliveredToWarehouseAt'];
    amount = json['amount'];
    size = json['size'];
    isPaid = json['isPaid'];
    priority = json['priority'];
    partialDelivery = json['partialDelivery'];
    // if (json['additionalExpenses'] != null) {
    //   additionalExpenses = <Null>[];
    //   json['additionalExpenses'].forEach((v) {
    //     // additionalExpenses!.add(new Null.fromJson(v));
    //   });
    // }
    id = json['id'];
    deleted = json['deleted'];
    creationDate = json['creationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['customerName'] = this.customerName;
    data['customerPhoneNumber'] = this.customerPhoneNumber;
    if (this.pickupZone != null) {
      data['pickupZone'] = this.pickupZone!.toJson();
    }
    if (this.deliveryZone != null) {
      data['deliveryZone'] = this.deliveryZone!.toJson();
    }
    data['status'] = this.status;
    data['content'] = this.content;
    // if (this.statusHistories != null) {
    //   data['statusHistories'] =
    //       this.statusHistories!.map((v) => v.toJson()).toList();
    // }
    if (this.merchant != null) {
      data['merchant'] = this.merchant!.toJson();
    }
    // data['pickupDelegate'] = this.pickupDelegate;
    // data['deliveryDelegate'] = this.deliveryDelegate;
    // data['pickupDelegateAssignedAt'] = this.pickupDelegateAssignedAt;
    // data['pickedUpAt'] = this.pickedUpAt;
    // data['deliveryDelegateAssignedAt'] = this.deliveryDelegateAssignedAt;
    // data['deliveryStartedAt'] = this.deliveryStartedAt;
    // data['deliveredToCustomerAt'] = this.deliveredToCustomerAt;
    // data['deliveredToWarehouseAt'] = this.deliveredToWarehouseAt;
    data['amount'] = this.amount;
    data['size'] = this.size;
    data['isPaid'] = this.isPaid;
    data['priority'] = this.priority;
    data['partialDelivery'] = this.partialDelivery;
    // if (this.additionalExpenses != null) {
    //   // data['additionalExpenses'] =
    //   // this.additionalExpenses!.map((v) => v.toJson()).toList();
    // }
    data['id'] = this.id;
    data['deleted'] = this.deleted;
    data['creationDate'] = this.creationDate;
    return data;
  }
}
