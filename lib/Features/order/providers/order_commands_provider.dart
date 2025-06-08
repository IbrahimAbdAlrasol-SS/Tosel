import 'dart:async';
import 'package:Tosell/Features/orders/models/Order.dart';
import 'package:Tosell/Features/order/models/Location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Tosell/Features/order/models/add_order_form.dart';
import 'package:Tosell/Features/orders/services/orders_service.dart';

part 'order_commands_provider.g.dart';

@riverpod
class OrderCommandsNotifier extends _$OrderCommandsNotifier {
  final OrdersService _service = OrdersService();

  Future<(Order?, String?)> changeOrderState({required String code}) async {
    return (await _service.changeOrderState(code: code));
  }

  Future<(Order? order, String? error)> addOrder( AddOrderForm form) async {
    // Set the state to loading before starting the async operation
    state = const AsyncValue.loading();
    try {
      // Perform the API call to add the order
      var result = await _service.addOrder(orderForm: form);

      // Update the state with the result if successful
      state = const AsyncValue.data([]);
      if (result.$1 == null) return (null, result.$2);
      return (result.$1, null); // success result
    } catch (e) {
      // If there's an error, update the state with an error
      state = AsyncError(e, StackTrace.current);
      return (null, e.toString()); // return error
    }
  }

  Future<bool> validateCode({
    required String code,
  }) async {
    var result = await _service.validateCode(code: code);
    return result;
  }

  @override
  FutureOr<void> build() async {}
}

final getOrderByCodeProvider =
    FutureProvider.family<Order?, String>((ref, code) async {
  final service = OrdersService(); // or inject via ref if needed
  return service.getOrderByCode(code: code);
});

final changeOrderStateProvider =
    FutureProvider.family<Order?, String>((ref, code) async {
  try {
    final service = OrdersService(); // or inject via ref if needed
    return service.getOrderByCode(code: code);
  } catch (e) {
    return (null);
  }
});
