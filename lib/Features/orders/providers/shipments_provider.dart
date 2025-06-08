import 'dart:async';
import 'package:Tosell/Features/orders/models/Shipment.dart';
import 'package:Tosell/Features/orders/services/shipments_service.dart';
import 'package:Tosell/core/Client/ApiResponse.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Tosell/Features/order/models/add_order_form.dart';

part 'shipments_provider.g.dart';

@riverpod
class ShipmentsNotifier extends _$ShipmentsNotifier {
  final ShipmentsService _service = ShipmentsService();

  Future<ApiResponse<Shipment>> getAll(
      {int page = 1, Map<String, dynamic>? queryParams}) async {
    return (await _service.getAll(queryParams: queryParams, page: page));
  }

  @override
  FutureOr<List<Shipment>> build() async {
    var result = await getAll();
    return result.data ?? [];
  }
}
