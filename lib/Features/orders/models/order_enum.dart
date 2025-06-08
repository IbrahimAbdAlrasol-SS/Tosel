import 'package:flutter/material.dart';

class OrderEnum {
  String? name;
  Color? textColor;
  String? icon;
  Color? iconColor;

  Color? color;
  String? description;
  int? value;

  OrderEnum({
    this.name,
    this.icon,
    this.color,
    this.value,
    this.description,
    this.iconColor,
    this.textColor,
  });
}

var orderStatus = [
  //? index = 0
  OrderEnum(
      name: 'في الانتطار',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'طلبك قيد انتظار الموافقة',
      value: 0),
  //? index = 1
  OrderEnum(
      name: 'قائمة استحصال',
      color: const Color(0xFFE5F6FF),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'في قائمة الاستحصال',
      value: 1),
  //? index = 2
  OrderEnum(
      name: 'قيد الاستحصال',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: ' طلبك قيد الاستحصال من قبل المندوب',
      value: 2),
  //? index = 3
  OrderEnum(
      name: 'تم الاستحصال',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم استحصال الطلب من قبل المندوب',
      value: 3),
  //? index = 4
  OrderEnum(
      name: 'غير مستحصل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'لم يتم استحصال الطلب من قبل المندوب',
      value: 4),
  //? index = 5
  OrderEnum(
      name: 'في المخزن',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم وصول الطلب الى المخزن',
      value: 5),
  //? index = 6
  OrderEnum(
      name: 'قائمة التوصيل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'طلبك في قائمة التوصيل للزبون',
      value: 6),
  //? index = 7
  OrderEnum(
      name: 'قيد التوصيل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'طلبك قيد التوصيل للزبون',
      value: 7),
  // ? index = 8
  OrderEnum(
      name: 'تم التوصيل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم ايصال الطلب للزبون',
      value: 8),
  //? index = 9
  OrderEnum(
      name: 'توصيل جزئي',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم الايصال الجزئي للزبون',
      value: 9),
  //? index = 10
  OrderEnum(
      name: 'اعادة جدولة',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم اعادة جدولة موعد الطلب',
      value: 10),
  //? index = 11
  OrderEnum(
      name: 'ملغي',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم الغاء الطلب',
      value: 11),
  //? index = 12
  OrderEnum(
      name: 'مرتجع',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم ارجاع الطلب للمندوب',
      value: 12),
  //? index = 13
  OrderEnum(
      name: 'منتهي',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم تصفية الحساب',
      value: 13),

//? 0-        Pending,  - في الانتظار
//? 1-        InPickUpShipment, - استحصال قائمة
//? 2-        InPickUpProgress, - قيد الاستحصال
//? 3-        Received, - تم الاستحصال
//? 4-        NotReceived, - لم يتم الاستحصال
//? 5-        InWarehouse, - في المخزن
//? 6-        InDeliveryShipment, - قائمة التوصيل
//? 7-        InDeliveryProgress, - قيد التوصيل
//? 8-        Delivered, - تم التوصيل
//? 9-       PartiallyDelivered, - توصيل جزئي
//? 10-       Rescheduled, - اعادة جدولة
//? 11-       Cancelled, - ملغي
//? 12-       Refunded, - مرتجع
//? 13-       Completed, - منتهي
];

// ignore: unused_element

class OrderSizeEnum {
  String? name;

  int? value;

  OrderSizeEnum({
    this.name,
    this.value,
  });
}

var orderSizes = [
  OrderSizeEnum(name: 'صغير', value: 0),
  OrderSizeEnum(name: 'متوسط', value: 1),
  OrderSizeEnum(name: 'كبير', value: 2),
];
