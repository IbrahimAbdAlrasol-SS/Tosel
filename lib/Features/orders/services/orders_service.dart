import 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/core/Client/ApiResponse.dart';
import 'package:Tosell/Features/orders/models/Order.dart';
import 'package:Tosell/Features/order/models/add_order_form.dart';

class OrdersService {
  final BaseClient<Order> baseClient;

  OrdersService()
      : baseClient =
            BaseClient<Order>(fromJson: (json) => Order.fromJson(json));

  Future<ApiResponse<Order>> getOrders(
      {int page = 1, Map<String, dynamic>? queryParams}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: '/order/merchant', page: page, queryParams: queryParams);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<(Order?, String?)> changeOrderState({String? code}) async {
    try {
      var result =
          await baseClient.update(endpoint: '/order/$code/advance-step');
      return (result.singleData, result.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order?>? getOrderByCode({required String code}) async {
    try {
      var result = await baseClient.getById(endpoint: '/order', id: code);
      return result.singleData;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> validateCode({required String code}) async {
    try {
      var result =
          await BaseClient<bool>().get(endpoint: '/order$code/available');
      return result.singleData ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future<(Order? order, String? error)> addOrder(
      {required AddOrderForm orderForm}) async {
    try {
      var result =
          await baseClient.create(endpoint: '/order', data: orderForm.toJson());
      if (result.singleData == null) return (null, result.message);

      return (result.singleData, null);
    } catch (e) {
      rethrow;
    }
  }
}
