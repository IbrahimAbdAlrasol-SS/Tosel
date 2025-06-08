import 'package:Tosell/Features/orders/models/Order.dart';

class Home {
  int? pending; //
  int? inWarehouse; //
  int? inPickUpProgress; //
  int? inDeliveryProgress; //
  int? delivered; //
  int? others; //
  double? dailyProfits;
  int? dailyDoneOrders; //
  int? dailyReturnedOrders; //
  // List<Null>? notifications;
  List<Order>? orders;

  Home(
      {this.pending,
      this.inWarehouse,
      this.inPickUpProgress,
      this.inDeliveryProgress,
      this.delivered,
      this.others,
      this.dailyProfits,
      this.dailyDoneOrders,
      this.dailyReturnedOrders,
      // this.notifications,
      this.orders});

  Home.fromJson(Map<String, dynamic> json) {
    pending = json['pending'];
    inWarehouse = json['inWarehouse'];
    inPickUpProgress = json['inPickUpProgress'];
    inDeliveryProgress = json['inDeliveryProgress'];
    delivered = json['delivered'];
    others = json['others'];
    dailyProfits = json['dailyProfits'];
    dailyDoneOrders = json['dailyDoneOrders'];
    dailyReturnedOrders = json['dailyReturnedOrders'];
    // if (json['notifications'] != null) {
    //   notifications = <Null>[];
    //   json['notifications'].forEach((v) {
    //     notifications!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending'] = this.pending;
    data['inWarehouse'] = this.inWarehouse;
    data['inPickUpProgress'] = this.inPickUpProgress;
    data['inDeliveryProgress'] = this.inDeliveryProgress;
    data['delivered'] = this.delivered;
    data['others'] = this.others;
    data['dailyProfits'] = this.dailyProfits;
    data['dailyDoneOrders'] = this.dailyDoneOrders;
    data['dailyReturnedOrders'] = this.dailyReturnedOrders;
    // if (this.notifications != null) {
    //   data['notifications'] =
    //       this.notifications!.map((v) => v.toJson()).toList();
    // }
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
