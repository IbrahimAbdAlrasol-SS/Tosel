import 'package:Tosell/Features/order/models/Location.dart';

class AddOrderForm {
  String? code;
  String? customerName;
  String? customerPhoneNumber;
  String? customerSecondPhoneNumber;
  String? deliveryZoneId;
  String? pickupZoneId;
  String? content;
  String? note;
  int? size;
  Location? pickUpLocation;
  String? amount;

  AddOrderForm({
    this.code,
    this.customerName,
    this.customerPhoneNumber,
    this.customerSecondPhoneNumber,
    this.deliveryZoneId,
    this.pickupZoneId,
    this.content,
    this.note,
    this.size,
    this.amount,
    this.pickUpLocation,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['customerName'] = customerName;
    data['customerPhoneNumber'] = customerPhoneNumber;
    data['customerSecondPhoneNumber'] = customerSecondPhoneNumber;
    data['deliveryZoneId'] = deliveryZoneId;
    data['pickupZoneId'] = pickupZoneId;
    data['content'] = content;
    data['note'] = note;
    data['size'] = size;
    data['pickUpLocation'] = pickUpLocation?.toJson();
    data['amount'] = amount;
    return data;
  }
}
